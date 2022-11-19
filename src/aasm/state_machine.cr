class AASM::StateMachine
  getter current_state_name

  include JSON::Serializable

  def to_json
    {
      states:             @states,
      events:             @events,
      transition_table:   @transition_table,
      current_state_name: @current_state_name,
    }.to_json
  end

  def initialize
    @states = {} of Symbol => State
    @events = {} of Symbol => Event
    @transition_table = {} of Symbol => Array(Symbol)
  end

  def state(name : Symbol, initial : Bool = false, enter : (-> _)? = nil, guard : (-> Bool)? = nil)
    check_states_already_defined name
    state = State.new({enter: enter, guard: guard})
    @current_state_name = name if initial || @current_state_name.nil?
    @states[name] = state
  end

  def event(name : Symbol)
    check_events_already_defined name
    event = Event.new
    yield event
    check_transitions_exist event.transition
    event.transition.each do |transition|
      check_states_exist transition.from + [transition.to]
      transition.from.each { |s| (@transition_table[s] ||= [] of Symbol) << transition.to }
    end
    @events[name] = event
  end

  def next_state
    @transition_table[@current_state_name]?.try &.first
  end

  def fire_event(event_name : Symbol, raise_exception = false)
    check_events_exist event_name

    event = @events[event_name]
    found_transition = event.transition.find { |subject| subject.from.includes? @current_state_name }

    if transition = found_transition
      event.before.try &.call
      state = @states[transition.to]
      if state.guard.nil? || state.guard.not_nil!.call
        state.enter.try &.call
        @current_state_name = transition.to
      end
      event.after.try &.call
    else
      raise UnableToChangeStateException.new(@current_state_name) if raise_exception
    end
  end

  private def check_transitions_exist(transitions)
    raise NoTransitionsException.new if transitions.empty?
  end

  private def check_states_exist(state_names)
    state_names.each do |state_name|
      raise NoSuchStateException.new state_name unless @states[state_name]?
    end
  end

  private def check_states_already_defined(*state_names)
    state_names.each do |state_name|
      raise StateAlreadyDefinedException.new state_name if @states[state_name]?
    end
  end

  private def check_events_exist(*event_names)
    event_names.each do |event_name|
      raise NoSuchEventException.new event_name unless @events[event_name]?
    end
  end

  private def check_events_already_defined(*event_names)
    event_names.each do |event_name|
      raise EventAlreadyDefinedException.new event_name if @events[event_name]?
    end
  end
end

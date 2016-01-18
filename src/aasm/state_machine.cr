class AASM::StateMachine

  getter current_state_name

  def initialize
    @states = {} of Symbol => State
    @events = {} of Symbol => Event
    @transition_table = [] of Transition
  end

  def state(name : Symbol, initial = false : Bool, enter = nil : (->), guard = nil : (-> Bool))
    check_states_already_defined name
    state = State.new({enter: enter, guard: guard})
    @current_state_name = name if initial || @current_state_name.nil?
    @states[name] = state
  end

  def event(name : Symbol)
    check_events_already_defined name
    event = Event.new
    yield event
    transition = event.transition
    check_states_exist transition.from + [transition.to]
    @transition_table << transition
    @events[name] = event
  end

  def next_state
    @transition_table.each do |t|
      return t.to if t.from.includes? @current_state_name
    end
    nil
  end

  def fire_event(event_name : Symbol, raise_exception = false)
    check_events_exist event_name

    transition = @events[event_name].transition
    if transition.from.includes? @current_state_name
      state = @states[transition.to]
      if state.guard.nil? || state.guard.not_nil!.call
        state.enter.try &.call
        @current_state_name = transition.to
      end
    else
      raise UnableToChangeState.new(@current_state_name, transition.to) if raise_exception
    end
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

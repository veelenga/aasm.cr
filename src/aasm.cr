require "./aasm/*"

module AASM
  abstract def act_as_state_machine

  def aasm
    @aasm ||= AASM::StateMachine.new
  end

  def state
    aasm.current_state_name
  end

  def next_state
    aasm.next_state
  end

  def fire(event : Symbol)
    aasm.fire event
  end

  def fire!(event : Symbol)
    aasm.fire event, true
  end
end

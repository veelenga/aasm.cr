require "../spec_helper"

def one_state_machine(enter = ->{}, guard = ->{ true })
  AASM::StateMachine.new.tap do |s|
    s.state :started, initial: true, enter: enter, guard: guard
    s.event :restart do |e|
      e.transitions from: :started, to: :started
    end
  end
end

def two_states_machine(enter = ->{}, guard = ->{ true })
  AASM::StateMachine.new.tap do |s|
    s.state :pending, initial: true
    s.state :active, enter: enter, guard: guard
    s.event :activate do |e|
      e.transitions from: :pending, to: :active
    end
  end
end

def three_states_machine(enter1 = ->{}, guard1 = ->{ true }, enter2 = ->{}, guard2 = ->{ true })
  AASM::StateMachine.new.tap do |s|
    s.state :pending, initial: true
    s.state :active, enter: enter1, guard: guard1
    s.state :completed, enter: enter2, guard: guard2
    s.event :activate do |e|
      e.transitions from: :pending, to: :active
    end
    s.event :complete do |e|
      e.transitions from: [:active, :pending], to: :completed
    end
  end
end

module AASM
  describe StateMachine do
    describe "#state" do
      it "defines new state" do
        StateMachine.new.tap(&.state :pending)
      end

      it "marks state as initial" do
        s = StateMachine.new
        s.state :active
        s.state :pending, initial: true
        s.current_state_name.should eq :pending
      end

      it "marks first state as initial if initial not set" do
        s = StateMachine.new
        s.state :pending
        s.state :active
        s.current_state_name.should eq :pending
      end

      it "accepts enter hook" do
        StateMachine.new.tap(&.state :pending, enter: ->{})
      end

      it "accepts guard hook" do
        StateMachine.new.tap(&.state :pending, guard: ->{ false })
      end

      it "raises exception if state already defined" do
        s = StateMachine.new
        s.state :pending
        expect_raises(StateAlreadyDefinedException) { s.state :pending }
      end
    end

    describe "#event" do
      it "defines new event" do
        s = StateMachine.new
        s.state :pending
        s.state :active
        s.event :activate { |e| e.transitions from: :pending, to: :active }
      end

      it "raises exception if such state not exists" do
        expect_raises(NoSuchStateException) do
          StateMachine.new.event :activate do |e|
            e.transitions from: :no_such_state, to: :no_such_state
          end
        end
      end

      it "raises exception if transitions not defined" do
        expect_raises(Exception) { StateMachine.new.event :activate { } }
      end

      it "raises exception if event already defined" do
        s = StateMachine.new
        s.state :pending
        s.state :active
        s.event :activate { |e| e.transitions from: :pending, to: :active }
        expect_raises(EventAlreadyDefinedException) do
          s.event :activate { |e| e.transitions from: :active, to: :pending }
        end
      end
    end

    describe "#next_state" do
      it "returns the next state in intial state" do
        s = two_states_machine
        s.next_state.should eq :active
      end

      it "returns the next state in not initial state" do
        s = three_states_machine
        s.fire_event :activate
        s.next_state.should eq :completed
      end

      it "returns nil in final state" do
        s = two_states_machine
        s.fire_event :activate
        s.next_state.should eq nil
      end
    end

    describe "#fire_event" do
      it "fires event and changes a state" do
        s = two_states_machine
        s.fire_event :activate
        s.current_state_name.should eq :active
      end

      it "does not change a state if guard returns false" do
        s = two_states_machine guard: ->{ false }
        s.fire_event :activate
        s.current_state_name.should eq :pending
      end

      it "changes a state if guard returns true" do
        s = two_states_machine guard: ->{ true }
        s.fire_event :activate
        s.current_state_name.should eq :active
      end

      it "runs enter block" do
        count = 0
        s = two_states_machine enter: ->{ count += 1; nil }
        s.fire_event :activate
        count.should eq 1
      end

      it "does not run enter block if guard returns false" do
        count = 0
        s = two_states_machine enter: ->{ count += 1; nil }, guard: ->{ false }
        s.fire_event :activate
        count.should eq 0
      end

      it "should not run block twice if event gets fired twice" do
        count = 0
        s = two_states_machine enter: ->{ count += 1; nil }
        s.fire_event :activate
        s.fire_event :activate
        count.should eq 1
      end

      it "should handle cycled states" do
        count = 0
        s = one_state_machine enter: ->{ count += 1; nil }
        s.fire_event :restart
        s.current_state_name.should eq :started
        count.should eq 1
      end

      it "runs before and after blocks" do
        count = 0
        s = StateMachine.new
        s.state :start
        s.event :restart do |e|
          e.before { count += 1 }
          e.after { count += 2 }
          e.transitions from: :start, to: :start
        end
        s.fire_event :restart
        count.should eq 3
      end

      it "raises exception if no such event" do
        s = StateMachine.new
        expect_raises(NoSuchEventException) { s.fire_event :activate }
      end

      it "should not change state if from state is wrong" do
        s = StateMachine.new
        s.state :pending, initial: true
        s.state :active
        s.state :completed
        s.event :complete { |e| e.transitions from: :active, to: :completed }
        s.fire_event :complete
        s.current_state_name.should eq :pending
      end

      it "should raise exception if from state is wrong and raise_exception state enabled" do
        s = StateMachine.new
        s.state :pending, initial: true
        s.state :active
        s.state :completed
        s.event :complete { |e| e.transitions from: :active, to: :completed }
        expect_raises(UnableToChangeState) { s.fire_event :complete, true }
      end
    end
  end
end

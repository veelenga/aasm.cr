require "./spec_helper"

class Transaction
  include AASM

  property :count

  def initialize(@count = 0)
  end

  def act_as_state_machine
    aasm.state :pending, initial: true
    aasm.state :active, enter: ->{ @count += 1 }
    aasm.state :completed

    aasm.event :activate do |e|
      e.transitions from: :pending, to: :active
    end

    aasm.event :complete do |e|
      e.transitions from: :active, to: :completed
    end
  end
end

def act_as_state_machine
  Transaction.new.tap &.act_as_state_machine
end

describe AASM do
  describe "when it does not act as state machine" do
    it "has no information regarding states" do
      Transaction.new.state.should be_nil
      Transaction.new.next_state.should be_nil
    end

    it "raises exception on fire" do
      expect_raises { Transaction.new.fire :activate }
      expect_raises { Transaction.new.fire! :activate }
    end
  end

  describe "when it acts as state machine" do
    it "returns current state" do
      act_as_state_machine.state.should eq :pending
    end

    it "returns next state" do
      act_as_state_machine.next_state.should eq :active
    end

    it "can fire event and change state" do
      t = act_as_state_machine
      t.fire :activate
      t.state.should eq :active
      t.next_state.should eq :completed
    end

    it "raises exception on fire! if wrong event fired" do
      t = act_as_state_machine
      expect_raises(AASM::AASMException) { t.fire! :complete }
    end
  end
end

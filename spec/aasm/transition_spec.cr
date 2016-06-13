require "../spec_helper"

module AASM
  describe Transition do
    describe "#new" do
      it "accepts :from and :to" do
        t = Transition.new({from: :pending, to: :active})
        t.from.should eq [:pending]
        t.to.should eq :active
      end

      it "accepts :from as Array" do
        t = Transition.new({from: [:pending, :completed], to: :active})
        t.from.should eq [:pending, :completed]
        t.to.should eq :active
      end
    end
  end
end

require "../spec_helper"

module AASM
  describe Transition do
    describe "#new" do
      it "accepts :from and :to" do
        t = Transition.new({from: :pending, to: :active})
        t.from.should eq :pending
        t.to.should eq :active
      end

      it "requires :form" do
        expect_raises(KeyError) { Transition.new({to: :active}) }
      end

      it "requires :to" do
        expect_raises(KeyError) { Transition.new({from: :pending}) }
      end
    end
  end
end

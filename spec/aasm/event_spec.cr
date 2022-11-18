require "../spec_helper"

module AASM
  describe Event do
    describe "#new" do
      it "requires nothing" do
        Event.new
      end

      it "accepts Transition" do
        e = Event.new [Transition.new({from: :pending, to: :active})]
        e.transition.should_not be_empty
      end
    end

    describe "#transitions" do
      it "creates new transition" do
        e = Event.new
        e.transitions(from: :pending, to: :active)
        e.transition.should_not be_empty
      end

      it "adds more transitions" do
        e = Event.new
        e.transitions(from: :pending, to: :active)
        e.transitions(from: :active, to: :competed)
        e.transition.first.from.should eq [:pending]
        e.transition.first.to.should eq :active
        e.transition.last.from.should eq [:active]
        e.transition.last.to.should eq :competed
        e.transition.size.should eq(2)
      end
    end

    describe "#before" do
      it "accepts before block" do
        e = Event.new
        e.before.should be_nil
        e.before { 10 }
        e.before.should_not be_nil
      end
    end

    describe "#after" do
      it "accepts after block" do
        e = Event.new
        e.after.should be_nil
        e.after { 20 }
        e.after.should_not be_nil
      end
    end
  end
end

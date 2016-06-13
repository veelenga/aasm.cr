require "../spec_helper"

module AASM
  describe State do
    describe "#new" do
      it "requires nothing" do
        t = State.new
        t.enter.should be_nil
        t.guard.should be_nil
      end

      it "accepts :enter" do
        t = State.new({enter: ->{}})
        t.enter.should_not be_nil
      end

      it "accepts :guard" do
        t = State.new({guard: ->{ true }})
        t.guard.should_not be_nil
      end
    end
  end
end

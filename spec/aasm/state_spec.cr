require "../spec_helper"

module AASM
  describe State do
    describe "#new" do
      it "requires nothing" do
        State.new({} of Symbol => (Nil | Symbol | ( -> Nil) | ( -> Bool)))
      end

      it "accepts :enter" do
        t = State.new({enter: ->{}})
        t.enter.should_not be_nil
      end

      it "accepts :guard" do
        t = State.new({guard: ->{}})
        t.guard.should_not be_nil
      end
    end
  end
end

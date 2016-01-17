require "../spec_helper"

module AASM
  describe NoSuchEventException do
    it "raises" do
      expect_raises(AASMException) { raise NoSuchEventException.new :activate }
    end
  end

  describe EventAlreadyDefinedException do
    it "raises" do
      expect_raises(AASMException) { raise EventAlreadyDefinedException.new :activate }
    end
  end

  describe NoSuchStateException do
    it "raises" do
      expect_raises(AASMException) { raise NoSuchStateException.new :pending }
    end
  end

  describe StateAlreadyDefinedException do
    it "raises" do
      expect_raises(AASMException) { raise StateAlreadyDefinedException.new :pending }
    end
  end

  describe UnableToChangeState do
    it "raises" do
      expect_raises(AASMException) { raise UnableToChangeState.new :pending, :active }
    end
  end
end

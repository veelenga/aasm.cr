class AASM::Event
  getter! :transition
  getter :before, :after

  def initialize(@transition : Array(Transition) = Array(Transition).new)
  end

  def transitions(from : (Symbol | Array(Symbol)) = nil, to : Symbol = nil)
    @transition << Transition.new({from: from, to: to})
  end

  def before(&block)
    @before = block
  end

  def after(&block)
    @after = block
  end
end

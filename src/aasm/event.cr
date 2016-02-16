class AASM::Event

  getter! :transition
  getter :before, :after

  def initialize(@transition = nil : (Nil | Transition))
  end

  def transitions(from = nil : (Symbol | Array(Symbol)), to = nil : Symbol)
    @transition ||= Transition.new({from: from, to: to})
  end

  def before(&block)
    @before = block
  end

  def after(&block)
    @after = block
  end
end

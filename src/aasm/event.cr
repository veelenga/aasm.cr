class AASM::Event

  getter! :transition

  def initialize(@transition = nil : (Nil | Transition))
  end

  def transitions(from = nil : (Symbol | Array(Symbol)), to = nil : Symbol)
    @transition ||= Transition.new({from: from, to: to})
  end
end

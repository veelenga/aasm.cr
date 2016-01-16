class AASM::Event

  getter! :transition

  def transitions(from = nil : Symbol, to = nil : Symbol)
    @transition = Transition.new({from: from, to: to})
  end
end

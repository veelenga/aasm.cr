struct AASM::Transition

  getter! :from, :to

  def initialize(opts)
    from = opts[:from]
    if from.is_a? Symbol
      @from = [from]
    elsif from.is_a? Array(Symbol)
      @from = from
    end
    @to = opts[:to]
  end
end

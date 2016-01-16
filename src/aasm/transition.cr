struct AASM::Transition

  getter! :from, :to

  def initialize(opts)
    @from = opts[:from]
    @to = opts[:to]
  end
end

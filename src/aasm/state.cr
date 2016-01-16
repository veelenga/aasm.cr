struct AASM::State

  getter :enter, :guard

  def initialize(opts)
    @enter = opts[:enter]?
    @guard = opts[:guard]?
  end
end

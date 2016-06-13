struct AASM::State

  getter :enter, :guard
  @enter : ((->) | Nil)
  @guard : ((-> Bool) | Nil)

  def initialize(opts)
    @enter = opts[:enter]?
    @guard = opts[:guard]?
  end
end

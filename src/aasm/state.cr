struct AASM::State
  getter enter : (-> Nil)?
  getter guard : (-> Bool)?

  def initialize(opts = {enter: nil, guard: nil})
    @enter = opts[:enter]?
    @guard = opts[:guard]?
  end
end

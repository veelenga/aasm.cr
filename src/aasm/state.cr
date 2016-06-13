struct AASM::State
  getter enter : (-> Nil)?
  getter guard : (-> Bool)?

  def initialize(opts = {enter: nil, guard: nil})
    if enter = opts[:enter]?
      @enter = -> { enter.not_nil!.call; nil }
    end
    @guard = opts[:guard]?
  end
end

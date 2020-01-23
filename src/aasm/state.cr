struct AASM::State
  include JSON::Serializable

  def to_json
    {
      opts: @opts # ,
    # enter: @enter,
    # guard: @guard
    }.to_json
  end

  # Error: no overload matches 'Proc(Nil)#to_json' with type JSON::Builder

  getter enter : (-> Nil)?
  getter guard : (-> Bool)?

  def initialize(opts = {enter: nil, guard: nil})
    if enter = opts[:enter]?
      @enter = ->{ enter.not_nil!.call; nil }
    end
    @guard = opts[:guard]?
  end
end

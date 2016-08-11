require './module/Enum'

module SurfaceState
  extend Enum
  extend Forwardable

  SI = 0
  DA = 1

  def_delegators :keys, :values

  @contents = ["芝", "ダ"]
  
end

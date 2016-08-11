require './module/Enum'

module SexState
  extend Enum
  extend Forwardable

  S = 0
  M = 1
  U = 2

  def_delegators :keys, :values

  @contents = ["牡", "牝", "セ"]
  
end

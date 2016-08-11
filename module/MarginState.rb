require './module/Enum'

module MarginState
  extend Enum
  extend Forwardable

  HA = 0
  KU = 1
  AT = 2

  def_delegators :keys, :values

  @contents = ["ハナ", "クビ", "アタマ"]

end

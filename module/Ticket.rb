require './module/Enum'

module Ticket
  extend Enum
  extend Forwardable

  TA = 0
  FU = 1
  WA = 2
  URE = 3
  WAI = 4
  UTA = 5
  SANTAN = 6
  SANREN = 7

  def_delegators :keys, :values

  @contents = ["単勝", "複勝", "枠連", "馬連", "ワイド", "馬単", "三連単", "三連複"]

end

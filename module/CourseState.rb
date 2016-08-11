require './module/Enum'

module CourseState
  extend Enum
  extend Forwardable

  ST = 0
  RI = 1
  LE = 2
  OU = 3

  def_delegators :keys, :values

  @contents = ["直線", "右", "左", "外"]

end

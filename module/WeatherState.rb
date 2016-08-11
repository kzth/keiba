require './module/Enum'

module WeatherState
  extend Enum
  extend Forwardable

  SU = 0
  CL = 1
  RA = 2
  LR = 3
  SN = 4

  def_delegators :keys, :values, :value

  @contents = ['晴', '曇', '雨', '小雨', '雪']
  
end

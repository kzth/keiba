require 'tbpgr_utils'

module Enum
  def values
    constants.map{ |e| const_get(e) }
  end

  def keys
    constants
  end

  def value num
    @contents[num]
  end
end

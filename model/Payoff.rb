require 'active_record'

ActiveRecord::Base.establish_connection(
  "adapter" => "sqlite3",
  "database" => "./keiba.db"
)

class Payoff < ActiveRecord::Base
end

require 'active_record'

ActiveRecord::Base.establish_connection(
  "adapter" => "sqlite3",
  "database" => "./keiba.db"
)

class RaceInfo < ActiveRecord::Base
end

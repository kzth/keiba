require 'net/http'
require 'uri'
require 'kconv'

class RaceListScraper

  @@race_db_url_base = 'http://db.netkeiba.com'

  def self.extractRaceList(baseurl)
    res_race_list = []
    race_list_uri = URI.parse(baseurl)
    res = Net::HTTP.get_response(race_list_uri)
    race_list = res.body.scan(/\/race\/list\/\d{8}\//)
    race_list = race_list.uniq
    race_list.each do |race_day|
      race_day_uri = URI.parse(@@race_db_url_base + race_day)
      race_day_res = Net::HTTP.get_response(race_day_uri)
      race_list = race_day_res.body.scan(/\/race\/\d+\//)
      race_list = race_list.uniq
      res_race_list += race_list
    end
    res_race_list
  end

end

require './lib/RaceListScraper'
require './lib/RaceScraper'
require 'date'
require './module/WeatherState'

RACE_LIST_FILE = './race_list.txt'
NETKEIBA_DB_URL = 'http://db.netkeiba.com'

case
when ARGV[0] == 'collecturl'

  # 10年分のレース結果リストを取得する
  day = Date.new(2016, 6, 1)
  today = Date.today
  loop {
    race_list = []
    date = day.strftime("%Y%m")
    race_list.push RaceListScraper.extractRaceList 'http://db.netkeiba.com/?pid=race_top&date='+date

    File.open(RACE_LIST_FILE, 'a') do |f|
      race_list.each do |race|
        f.puts(race)
      end
    end

    day = day >> 1
    break if day > today
  }

  #RaceListScraper.scrape
when ARGV[0] == 'downloadpage'
when ARGV[0] == 'scrapehtml'

  File.open(RACE_LIST_FILE, 'r') do |f|
    f.each_line do |line|
      race_url = NETKEIBA_DB_URL + line.to_s

    end

  end

when ARGV[0] == 'extract'
when ARGV[0] == 'genfeature'
when ARGV[0] == 'test'
  RaceScraper.scrape "http://yahoo.co.jp"
else
  puts 'error'
end

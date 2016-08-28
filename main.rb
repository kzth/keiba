require './lib/RaceListScraper'
require './lib/RaceScraper'
require 'date'
require './module/WeatherState'

RACE_LIST_FILE = './race_list.txt'
NETKEIBA_DB_URL = 'http://db.netkeiba.com'

case
when ARGV[0] == 'collecturl'

  # 10年分のレース結果リストを取得する
  day = Date.new(2007, 1, 1)
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

when ARGV[0] == 'downloadpage'

  # レースページのhtmlをdownloadする
  File.open(RACE_LIST_FILE, 'r') do |f|
    f.each_line do |line|
      date = line.to_s.match /[0-9]{12}/
      puts date
      race_url = NETKEIBA_DB_URL + line.to_s.strip

      RaceScraper.downloadpage race_url, date
    end
  end

when ARGV[0] == 'scrapehtml'

  # DLしたhtmlをスクレイプしてDBに格納する
  dir_name = "./html"
  dir = Dir.open(dir_name)
  dir.each do |file|
    next if file.match /^\./
    next if file.match /^200808020398/
    next if file.match /^200808020399/

    html = File.open(dir_name + '/' + file).read

    id = file.match(/[0-9]{12}/).to_s.to_i

    RaceScraper.scrape html, id

  end

when ARGV[0] == 'extract'
when ARGV[0] == 'genfeature'
else
  puts 'error'
end

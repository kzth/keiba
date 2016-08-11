require 'open-uri'
require 'nokogiri'
require './model/RaceInfo'

class RaceScraper

  def self.downloadpage url, date

    html = open(url) do |f|
      f.read
    end

    RaceScraper.new.send :file_save, html, date

  end

  def self.scrape html

    charset = 'EUC-JP'
    doc = Nokogiri::HTML.parse(html, nil, charset)

      puts RaceScraper.new.send(:get_race_name, doc)
      puts RaceScraper.new.send(:get_surface, doc)
      puts RaceScraper.new.send(:get_distance, doc)
      puts RaceScraper.new.send(:get_weather, doc)
      puts RaceScraper.new.send(:get_surface_state, doc)
      puts RaceScraper.new.send(:get_race_start, doc)
      puts RaceScraper.new.send(:get_race_number, doc)
      puts RaceScraper.new.send(:get_surface_score, doc)
      puts RaceScraper.new.send(:get_date, doc)
      puts RaceScraper.new.send(:get_place_detail, doc)
      puts RaceScraper.new.send(:get_race_class, doc)

    RaceInfo.create(
      race_name: RaceScraper.new.send(:get_race_name, doc),
      surface: RaceScraper.new.send(:get_surface, doc),
      distance: RaceScraper.new.send(:get_distance, doc),
      weather: RaceScraper.new.send(:get_weather, doc),
      surface_state: RaceScraper.new.send(:get_surface_state, doc),
      race_start: RaceScraper.new.send(:get_race_start, doc),
      race_number: RaceScraper.new.send(:get_race_number, doc),
      surface_score: RaceScraper.new.send(:get_surface_score, doc),
      date: RaceScraper.new.send(:get_date, doc),
      place_detail: RaceScraper.new.send(:get_place_detail, doc),
      race_class: RaceScraper.new.send(:get_race_class, doc),
    )

  end

  private
  def file_save html, date

    save_dir = "html"
    FileUtils.mkdir_p save_dir unless FileTest.exist? save_dir

    save_file_path = "./html/" + date.to_s + ".html"
    File.open(save_file_path, 'w') do |f|
      f.puts html
    end
  end

  def get_race_name doc
    doc.css('.racedata h1').text
  end

  def get_surface doc
    info = doc.css('.racedata p').text.strip
    sur = info.split('/')[0]
    sur.match(/芝右|ダ右|障芝|芝右 外|障芝 ダート|ダ左|芝左|障芝 外|芝左 外|芝直線|障芝 外-内|障芝 内-外|芝右 内2周/)
  end

  def get_distance doc
    info = doc.css('.racedata p').text.strip
    num = info.split('/')[0]
    num.match(/[0-9]+/)
  end

  def get_weather doc
    info = doc.css('.racedata p').text.strip
    tmp = info.split('/')[1]
    tmp.match(/晴|曇|雨|小雨|雪/)
  end

  def get_surface_state doc
    info = doc.css('.racedata p').text.strip
    sur = info.split('/')[2]
    sur.match(/芝|ダート/)
  end

  def get_race_start doc
    info = doc.css('.racedata p').text.strip
    tmp = info.split('/')[3]
    tmp.match(/[0-9]{2}:[0-9]{2}/)
  end

  def get_race_number doc
    info = doc.css('.racedata dt').text.strip
    info.to_i
  end

  def get_surface_score doc
    1
  end

  def get_date doc
    info = doc.css('.smalltxt').text.strip
    date_jp = info.split(' ')[0]
    date = date_jp.scan(/[0-9]+/)
    Date.new(date[0].to_i, date[1].to_i, date[2].to_i)
  end

  def get_place_detail doc
    info = doc.css('.smalltxt').text.strip
    date_jp = info.split(' ')[1]
  end

  def get_race_class doc
    info = doc.css('.smalltxt').text.strip
    date_jp = info.split(' ')[2]
  end

end

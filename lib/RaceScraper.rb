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

    info = doc.css('.racedata p').text.strip
    puts info
    puts info.split('/')

    exit

=begin
    RaceInfo.create(
      race_name: doc.css('.racedata h1').text
      surface: doc.css '.racedata h1'
      distance: doc.css '.racedata h1'
      weather: doc.css '.racedata h1'
      surface_state: doc.css '.racedata h1'
      race_start: doc.css '.racedata h1'
      race_number: doc.css '.racedata h1'
      surface_score: doc.css '.racedata h1'
      date: doc.css '.racedata h1'
      place_detail: doc.css '.racedata h1'
      race_class: doc.css '.racedata h1'
    )
=end

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

end

require 'open-uri'
require 'nokogiri'

class RaceScraper

  def self.scrape url

    url = "http://db.netkeiba.com/race/201605010101/"

    charset = 'EUC-JP'
    html = open(url) do |f|
      f.read
    end

    doc = Nokogiri::HTML.parse(html, nil, charset)

    p doc.title
  end

end

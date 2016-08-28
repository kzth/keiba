require 'open-uri'
require 'nokogiri'
require './model/RaceInfo'
require './model/RaceResult'
require './model/Payoff'
require './module/SexState'
require './module/WeatherState'
require './module/SurfaceState'
require './module/Ticket'

class RaceScraper

  def self.downloadpage url, date

    html = open(url) do |f|
      f.read
    end

    RaceScraper.new.send :file_save, html, date

  end

  def self.scrape html, race_id

    puts race_id

    charset = 'EUC-JP'
    doc = Nokogiri::HTML.parse(html, nil, charset)

    RaceInfo.create(
      race_name: RaceScraper.new.send(:get_race_name, doc),
      surface: RaceScraper.new.send(:get_surface, doc),
      distance: RaceScraper.new.send(:get_distance, doc),
      weather: WeatherState::type(RaceScraper.new.send(:get_weather, doc)),
      surface_state: SurfaceState::type(RaceScraper.new.send(:get_surface_state, doc)),
      race_start: RaceScraper.new.send(:get_race_start, doc),
      race_number: RaceScraper.new.send(:get_race_number, doc),
      surface_score: RaceScraper.new.send(:get_surface_score, doc),
      date: RaceScraper.new.send(:get_date, doc),
      place_detail: RaceScraper.new.send(:get_place_detail, doc),
      race_class: RaceScraper.new.send(:get_race_class, doc),
    )

    num = doc.css('table.race_table_01 tr').count.to_i-1
    num.times do |i|

      next if i == 0

      RaceResult.create(
        race_id: race_id,
        order_of_finish: RaceScraper.new.send(:get_order_of_finish, doc, i),
        frame_number: RaceScraper.new.send(:get_frame_number, doc, i),
        horse_number: RaceScraper.new.send(:get_horse_number, doc, i),
        horse_id: RaceScraper.new.send(:get_hourse_id, doc, i),
        sex: SexState::type(RaceScraper.new.send(:get_sex, doc, i)),
        age: RaceScraper.new.send(:get_age, doc, i),
        basis_weight: RaceScraper.new.send(:get_basis_weight, doc, i),
        jockey_id: RaceScraper.new.send(:get_jockey_id, doc, i),
        finishing_time: RaceScraper.new.send(:get_finishing_time, doc, i),
        length: RaceScraper.new.send(:get_length, doc, i),
        speed_figure: RaceScraper.new.send(:get_speed_figure, doc, i),
        pass: RaceScraper.new.send(:get_pass, doc, i),
        last_phase: RaceScraper.new.send(:get_last_phase, doc, i),
        odds: RaceScraper.new.send(:get_odds, doc, i),
        popularity: RaceScraper.new.send(:get_popularity, doc, i),
        horse_weight: RaceScraper.new.send(:get_horse_weight, doc, i),
        remark: RaceScraper.new.send(:get_remark, doc, i),
        stable: RaceScraper.new.send(:get_stable, doc, i),
        trainer_id: RaceScraper.new.send(:get_trainer_id, doc, i),
        owner_id: RaceScraper.new.send(:get_owner_id, doc, i),
        earning_money: RaceScraper.new.send(:get_earning_money, doc, i)
      )
    end

    pay_num = doc.css('table.pay_table_01 tr').count.to_i
    pay_num.times do |i|

      td1 = doc.css('table.pay_table_01 tr')[1].css('td')[0].inner_html
      ticket_type = Ticket::type(RaceScraper.new.send(:get_ticket_type, doc, i))

      if td1.include?('<br>') then

        td1 = doc.css('table.pay_table_01 tr')[i].css('td')[0].inner_html
        td2 = doc.css('table.pay_table_01 tr')[i].css('td')[1].inner_html
        td3 = doc.css('table.pay_table_01 tr')[i].css('td')[2].inner_html
        td_ary1 = td1.split('<br>')
        td_ary2 = td2.split('<br>')
        td_ary3 = td3.split('<br>')

        td_ary1.count.times do |j|
          Payoff.create(
            race_id: race_id,
            ticket_type: ticket_type,
            horse_number: td_ary1[j].to_s,
            payoff: td_ary2[j].to_s.gsub(',', ''),
            popularity: td_ary3[j].to_s.to_i
          )
        end

      else

        td1 = doc.css('table.pay_table_01 tr')[i].css('td')[0].text
        td2 = doc.css('table.pay_table_01 tr')[i].css('td')[1].text
        td3 = doc.css('table.pay_table_01 tr')[i].css('td')[2].text
        Payoff.create(
          race_id: race_id,
          ticket_type: ticket_type,
          horse_number: td1.to_s,
          payoff: td2.to_s.gsub(',', ''),
          popularity: td3.to_s.to_i
        )

      end

    end

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
    surface = sur.match(/芝右|ダ右|障芝|芝右 外|障芝 ダート|ダ左|芝左|障芝 外|芝左 外|芝直線|障芝 外-内|障芝 内-外|芝右 内2周/)[0].to_s
    if sur.empty?
      "他"
    else
      surface
    end
  end

  def get_distance doc
    info = doc.css('.racedata p').text.strip
    num = info.split('/')[0]
    num.match(/[0-9]+/)[0].to_i
  end

  def get_weather doc
    info = doc.css('.racedata p').text.strip
    tmp = info.split('/')[1]
    tmp.match(/晴|曇|雨|小雨|雪/)[0].to_s
  end

  def get_surface_state doc
    info = doc.css('.racedata p').text.strip
    sur = info.split('/')[2]
    sur.match(/芝|ダート/)[0].to_s
  end

  def get_race_start doc
    info = doc.css('.racedata p').text.strip
    tmp = info.split('/')[3]
    tmp.match(/[0-9]{2}:[0-9]{2}/)[0].to_i
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

  def get_order_of_finish doc, num
    line = doc.css('table.race_table_01 tr')[num.to_i]
    line.css('td')[0].text
  end

  def get_frame_number doc, num
    line = doc.css('table.race_table_01 tr')[num.to_i]
    line.css('td')[1].text.to_i
  end

  def get_horse_number doc, num
    line = doc.css('table.race_table_01 tr')[num.to_i]
    line.css('td')[2].text.to_i
  end

  def get_hourse_id doc, num
    line = doc.css('table.race_table_01 tr')[num.to_i]
    line.css('td')[3].css('a')[0][:href].match(/[0-9]+/).to_s
  end

  def get_sex doc, num
    line = doc.css('table.race_table_01 tr')[num.to_i]
    line.css('td')[4].text.match(/牝|牡|セ/).to_s
  end

  def get_age doc, num
    line = doc.css('table.race_table_01 tr')[num.to_i]
    line.css('td')[4].text.match(/[0-9]+/).to_s.to_i
  end

  def get_basis_weight doc, num
    line = doc.css('table.race_table_01 tr')[num.to_i]
    line.css('td')[5].text.to_i
  end

  def get_jockey_id doc, num
    line = doc.css('table.race_table_01 tr')[num.to_i]
    line.css('td')[6].css('a')[0][:href].match(/[0-9]+/).to_s.to_i
  end

  def get_finishing_time doc, num
    line = doc.css('table.race_table_01 tr')[num.to_i]
    line.css('td')[7].text
  end

  def get_length doc, num
    line = doc.css('table.race_table_01 tr')[num.to_i]
    line.css('td')[8].text
  end

  def get_speed_figure doc, num
    1
  end

  def get_pass doc, num
    line = doc.css('table.race_table_01 tr')[num.to_i]
    line.css('td')[10].text
  end

  def get_last_phase doc, num
    line = doc.css('table.race_table_01 tr')[num.to_i]
    line.css('td')[11].text
  end

  def get_odds doc, num
    line = doc.css('table.race_table_01 tr')[num.to_i]
    line.css('td')[12].text
  end

  def get_popularity doc, num
    line = doc.css('table.race_table_01 tr')[num.to_i]
    line.css('td')[13].text.to_i
  end

  def get_horse_weight doc, num
    line = doc.css('table.race_table_01 tr')[num.to_i]
    line.css('td')[14].text
  end

  def get_remark doc, num
    "no comment"
  end

  def get_stable doc, num
    "no comment"
  end

  def get_trainer_id doc, num
    line = doc.css('table.race_table_01 tr')[num.to_i]
    line.css('td')[18].css('a')[0][:href].match(/[0-9]+/).to_s.to_i
  end

  def get_owner_id doc, num
    line = doc.css('table.race_table_01 tr')[num.to_i]
    line.css('td')[19].css('a')[0][:href].match(/[0-9]+/).to_s.to_i
  end

  def get_earning_money doc, num
    line = doc.css('table.race_table_01 tr')[num.to_i]
    line.css('td')[20].text
  end

  # payoff methods
  def get_ticket_type doc, num
    line = doc.css('table.pay_table_01 tr')[num.to_i]
    line.css('th').txext
  end

  def get_ticket_type doc, num
    line = doc.css('table.pay_table_01 tr')[num.to_i]
    line.css('th').text
  end
end

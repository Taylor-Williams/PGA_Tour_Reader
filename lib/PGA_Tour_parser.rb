require 'pry'
require 'date'
require 'open-uri'
require 'nokogiri'

require_relative './PGA_tournament.rb'
require_relative './PGA_season.rb'
require_relative './PGA_Tour_scraper.rb'

class PGA_Tour_Parser

  def self.date_parser(month, days)
    if /\d/ =~ month #when tourny weekend spans end of month
      start_date = Date.parse("#{month} #{@year}")
      end_date = Date.parse("#{days} #{@year}")
    else #when tourny weekend starts and ends same month
      days = days.split(" - ")
      start_date = Date.parse("#{month} #{days[0]} #{@year}")
      end_date = Date.parse("#{month} #{days[1]} #{@year}")
    end
    [set_year(start_date), set_year(end_date)]
  end

  def self.set_year(date)
    date.month.between?(10,12) ? date << 12 : date #new seasons start in oct (month 10)
  end

  def self.attribute_parser(tournament_info)
    attribute_text = tournament_info.children[4].text.split(/\s{2,}/)
    attribute_text.shift
    attributes = {
      :name => tournament_info.children[1].children[0].text,
      :url => url_parser(tournament_info),
      :course => attribute_text[0].split(",")[0],
      :location => "#{attribute_text[1]}#{attribute_text[2]}"[0..-2]
    }
    attributes[:purse] = "#{attribute_text[3].split(":")[1].strip}" if attribute_text.length == 4
    attributes
  end

  def self.url_parser(tournament_info)
    url = tournament_info.children[1].attributes["href"]
    if url
      url.value.start_with?("/") ? url = "https://www.pgatour.com#{url.value}" : url = url.value
    end
  end

end

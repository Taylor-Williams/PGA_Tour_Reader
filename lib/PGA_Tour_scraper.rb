require 'pry'
require 'date'
require 'open-uri'
require 'nokogiri'

require_relative 'PGA_tournament.rb'

class PGA_Tour_Scraper
  attr_accessor :path, :year, :tournaments
  @@all = []

  def initialize(path = "https://www.pgatour.com/tournaments/schedule.html", year = Time.now.strftime("%Y"))
    @path = path
    @tournaments = []
    @year = year
    save
    scrape_tour_page
  end

  def self.all
    @@all
  end

  def save
    self.class.all << self
  end

  def scrape_tour_page
    page = Nokogiri::HTML(open("#{@path}"))
    date_scraper(page) #instantiates all tournaments from this season by dates
    tournament_attributes = attribute_scraper(page)
    #zips together tournament attributes with tournament objects
    @tournaments.each_with_index do |tournament, index|
      tournament.add_attributes(tournament_attributes[index])
     end
  end

  def date_scraper(page)
    page.css('.num-date').each do |date_info|
      dates = date_parser(date_info.children[1].children.text, date_info.children[3].children.text.strip)
      @tournaments << PGA_Tournament.new(dates[0], dates[1])
    end
  end

  def date_parser(month, days)
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

  def set_year(date)
    date.month.between?(10,12) ? date << 12 : date #new seasons start in oct (month 10)
  end

  def attribute_scraper(page)
    attributes = page.css(".tournament-text").map do |tournament_info|
      detail_parser(tournament_info) #hash of tournament details
    end
  end

  def detail_parser(tournament_info)
    detail_text = tournament_info.children[4].text.split(/\s{2,}/)
    detail_text.shift
    details = {
      :name => tournament_info.children[1].children[0].text,
      :url => url_parser(tournament_info),
      :course => detail_text[0].split(",")[0],
      :location => "#{detail_text[1]}#{detail_text[2]}"[0..-2]
    }
    details[:purse] = "#{detail_text[3].slice(9..-1)}" if detail_text.length == 4
    details
  end

  def url_parser(tournament_info)
    url = tournament_info.children[1].attributes["href"]
    if url
      url.value.start_with?("/") ? url = "https://www.pgatour.com#{url.value}" : url = url.value
    end
  end

end

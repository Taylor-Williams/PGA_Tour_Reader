require 'pry'
require 'date'
require 'open-uri'
require 'nokogiri'

require_relative "../PGA_tournament.rb"

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
    date_scraper(page)
    tournament_attributes = attribute_scraper(page)

    @tournaments.each_with_index do |tournament, index|
      tournament.add_attributes(tournament_attributes[index - 1])
     end
  end

  def date_scraper(page)
    page.css('.num-date').each do |date_info|
      month = date_info.children[1].children.text
      days = date_info.children[3].children.text.strip
      if /\d/ =~ month #when tourny weekend spans end of month
        start_date = Date.parse("#{month} #{@year}")
        end_date = Date.parse("#{days} #{@year}")
      else #when tourny weekend starts and ends same month
        days = days.split(" - ")
        start_date = Date.parse("#{month} #{days[0]} #{@year}")
        end_date = Date.parse("#{month} #{days[1]} #{@year}")
      end
      start_date = set_year(start_date)
      end_date = set_year(end_date)
      @tournaments << PGA_Tournament.new(start_date, end_date)
    end
  end
  #seems like new seasons are always start in oct (month 10)
  def set_year(date)
    date.month.between?(10,12) ? date << 12 : date
  end

  def attribute_scraper(page)
    attributes = page.css(".tournament-text").map do |tournament_info|
      url = get_url(tournament_info)
      details = {
        :name => tournament_info.children[1].children[0].text,
        :url => url
      }
      weird_shit = tournament_info.children[4].text.split(/\s{2,}/)
      weird_shit.shift
      details[:course] = weird_shit[0].split(",")[0],
      details[:location] = "#{weird_shit[1]}#{weird_shit[2]}".strip
      details[:purse] = "#{weird_shit[3].slice(9..-1)}" if weird_shit.length == 4
      details
    end
  end

  def get_url(tournament_info)
    url = tournament_info.children[1].attributes["href"]
    if url
      url.value.start_with?("/") ? url = "https://www.pgatour.com#{url.value}" : url = url.value
    end
  end
end

blah = PGA_Tour_Scraper.new
blah.tournaments.each do |tournament|
  puts "#{tournament.url}, #{tournament.name}"
end

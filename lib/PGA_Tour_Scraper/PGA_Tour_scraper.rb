require 'pry'
require 'date'
require 'open-uri'
require 'nokogiri'

require_relative "../PGA_tournament.rb"

class PGA_Tour_Scraper
  attr_accessor :path, :year, :tournaments #year is in the form of a string
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
    page.css('.num-date').each do |date_info|
      month = date_info.children[1].children.text
      days = date_info.children[3].children.text.strip
      if /\d/ =~ month #when tourny weekend has 2 months
        #creates a month object for both scrapes
        start_date = Date.parse("#{month} #{@year}")
        start_date = start_date << 12 if start_date.month.between?(10,12)
        end_date = Date.parse("#{days} #{@year}")
        end_date = end_date << 12 if start_date.month.between?(10,12)
        @tournaments << PGA_Tournament.new(start_date, end_date)
      else
        days = days.split(" - ")
        start_date = Date.parse("#{month} #{days[0]} #{@year}")
        start_date = start_date << 12 if start_date.month.between?(10,12)
        end_date = Date.parse("#{month} #{days[1]} #{@year}")
        end_date = end_date << 12 if start_date.month.between?(10,12)
        @tournaments << PGA_Tournament.new(start_date, end_date)
      end
    end
    attributes = page.css(".tournament-text").map do |tournament_info|
      tournament_info.children[1].children[0].text
      tournament_info.children[1].attributes["href"].value if tournament_info.children[1].attributes["href"]
      weird_shit = tournament_info.children[4].text.split(/\s{2,}/)
      weird_shit.shift
      puts weird_shit
      details = {
        :course => weird_shit[0].split(",")[0],
        :location => "#{weird_shit[1]}#{weird_shit[2]}".strip
      }
      details[:purse] = "#{weird_shit[3].slice(9..-1)}" if weird_shit.length == 4
      details
    end
    @tournaments.each_with_index{|tournament, index| tournament.add_attributes(attributes[index - 1])}
  end
end

blah = PGA_Tour_Scraper.new
blah2 = blah.scrape_tour_page
puts blah2
# blah.tournaments.each do |tournament|
#   puts tournament.start_date
#   puts tournament.end_date
# end

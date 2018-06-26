require 'pry'
require 'date'
require 'open-uri'
require 'nokogiri'

require_relative './PGA_tournament.rb'
require_relative './PGA_season.rb'
require_relative './PGA_Tour_parser.rb'

class PGA_Tour_Scraper
  attr_accessor :path, :year, :season

  def initialize(year = Time.now.strftime("%Y"), path = "https://www.pgatour.com/tournaments/schedule.html")
    @path = path
    @year = year
    @season = PGA_Season.new(@year)
    scrape_tour_page
  end

  def scrape_tour_page
    page = Nokogiri::HTML(open("#{@path}"))
    date_scraper(page) #instantiates all tournaments from this season by dates
    tournament_attributes = attribute_scraper(page)
    #zips together tournament attributes with tournament objects
    @season.tournaments.each_with_index {|tournament, index| tournament.add_attributes(tournament_attributes[index])}
  end

  def date_scraper(page)
    page.css('.num-date').each do |date_info|
      dates = PGA_Tour_Parser.date_parser(date_info.children[1].children.text, date_info.children[3].children.text.strip)
      @season.tournaments << PGA_Tournament.new(dates[0], dates[1])
    end
  end

  def attribute_scraper(page)
    page.css(".tournament-text").map {|tournament_info| PGA_Tour_Parser.attribute_parser(tournament_info)}
  end
end

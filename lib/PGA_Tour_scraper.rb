require_relative './PGA_Tour_parser.rb'

class PGATourReader::PGA_Tour_Scraper
  include PGA_Tour_Parser

  attr_accessor :path, :year, :season

  def initialize(year = Time.now.strftime("%Y"), path = "https://www.pgatour.com/tournaments/schedule.html")
    @path = path
    @year = year
    @season = PGATourReader::PGA_Season.new(@year)
    scrape_tour_page
  end

  #scrapes parses and zips all tournaments and their attributes for a season
  def scrape_tour_page
    page = Nokogiri::HTML(open("#{@path}"))
    date_scraper(page) #instantiates all tournaments from this season by dates
    tournament_attributes = attribute_scraper(page)
    #zips together tournament attributes with tournament objects
    @season.tournaments.each_with_index {|tournament, index| tournament.add_attributes(tournament_attributes[index])}
  end

  #scrapes all dates for a given season and returns an array of created Tournaments
  def date_scraper(page)
    page.css('.num-date').each do |date_info|
      dates = date_parser(date_info.children[1].children.text, date_info.children[3].children.text.strip)
      @season.tournaments << PGATourReader::PGA_Tournament.new(dates[0], dates[1], @season)
    end
  end

  #scrapes name location course url and purse data and returns them in a hash
  def attribute_scraper(page)
    page.css(".tournament-text").map {|tournament_info| attribute_parser(tournament_info)}
  end
end

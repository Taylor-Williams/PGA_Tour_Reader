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
      if /\d/ =~ month #when tourny weekend has 2 months
        #creates a month object for both scrapes
        start_date = Date.parse("#{month} #{@year}")
        end_date = Date.parse("#{date_info.children[3].children.text.strip} #{@year}")
        PGA_Tournament.new(start_date, end_date)
      else
        puts date_info.children[3].children.text.strip
      end
    end
  end
end

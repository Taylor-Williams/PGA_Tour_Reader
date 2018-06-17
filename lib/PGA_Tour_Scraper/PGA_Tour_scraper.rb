class PGA_Tour_Scraper
  attr_accessor :path, :year, :tournaments #year is in the form of a string
  @@all = []

  def initialize(path = "https://www.pgatour.com/tournaments/schedule.html", year = Time.now.strftime("%Y"))
    @path = path
    @tournaments = []
    save
  end

  def self.all
    @@all
  end

  def save
    self.class.all << self
  end

  def scrape_tour_page
    puts "blah"
  end
end

PGA_Tour_Scraper.new

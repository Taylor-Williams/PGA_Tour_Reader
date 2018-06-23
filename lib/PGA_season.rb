require 'date'
require_relative './PGA_tournament.rb'
class PGA_Season

  attr_accessor :year, :tournaments

  @@all = []

  def initialize(year, tournaments = [])
    @tournaments = tournaments
    save
  end

  def self.all
    @@all
  end

  def save
    self.class.all << self
  end

  def list_dates_names()
    @tournaments.each do |tournament|
      puts "#{tournament.start_date} - #{tournament.end_date}, #{tournament.name}"
    end
  end

  def self.get_tournaments_by_month(month_number, year = @year)
    season = self.all.detect {|season| season.year == year}
    if season
      got_tournaments = season.tournaments.select {|tournament| tournament.start_date.month == month_number || tournament.end_date.month == month_number}
      got_tournaments.each {|tourny| puts "#{tourny.start_date} - #{tourny.end_date} : #{tourny.name}"}
    else
      puts "I don't have the #{@year} season on file let me load the data"
      PGA_Tour_Scraper.new(year)
      self.get_tournaments_by_month(month_number, year)
    end
  end
end

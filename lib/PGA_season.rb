require 'date'
require_relative './PGA_tournament.rb'
class PGA_Season

  attr_accessor :year, :tournaments

  @@all = []

  def initialize(year, tournaments = [])
    @year = year
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

  def self.get_tournaments_by_month(month_number, year = Time.now.strftime("%Y"))
    season = self.all.detect {|season| season.year == year}
    if season
      got_tournaments = season.tournaments.select {|tournament| tournament.start_date.month == month_number.to_i || tournament.end_date.month == month_number.to_i}
      got_tournaments.each {|tourny| puts "#{tourny.start_date} - #{tourny.end_date} : #{tourny.name}"}
    else
      puts "I don't have the #{year} season on file let me load the data"
      PGA_Tour_Scraper.new(year)
      self.get_tournaments_by_month(month_number, year)
    end
  end

  def self.get_tournament(date, year = Time.now.strftime("%Y"))
    dates = date.split("/")
    puts "your requested date is: #{dates[0]}, #{dates[1]}, #{year}"
    if Date.valid_date?(year.to_i, dates[0].to_i, dates[1].to_i)
      tournament_date = Date.new(year.to_i, dates[0].to_i, dates[1].to_i)
      got_tournament = self.get_tournaments_by_month(dates[0]).detect do |tournament|
        (tournament_date <=> tournament.start_date) > -1 && (tournament_date <=> tournament.end_date) < 1
      end
       if got_tournament
         puts "you have selected the following tournament: #{got_tournament.start_date} - #{got_tournament.end_date} : #{got_tournament.name}"
         puts "here is some more information about that tournament:"
         got_tournament.list_attributes
       else
         puts "you didn't input a date when an official PGA tournament happened."
       end
    else
      puts "that date is invalid, make sure to use the format of mm/dd"
    end
  end
end

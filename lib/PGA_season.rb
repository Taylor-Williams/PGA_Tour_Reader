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

end

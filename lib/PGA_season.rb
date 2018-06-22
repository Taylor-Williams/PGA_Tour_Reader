require 'date'
require_relative './tournament.rb'
class PGA_Season

  attr_accessor :start_date, :end_date, :year, :tournaments

  @@all = []

  def initialize(start_date, end_date, year, tournaments = [])
    @start_date = start_date
    @end_date = end_date
    @tournaments = []
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

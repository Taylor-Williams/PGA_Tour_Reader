class PGATourReader::PGA_Season

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

  def list_all_for_season()
    @tournaments.each do |tournament|
      tournament.print_date_name
    end
  end

  def self.get_season_by_year(year)
    season = self.all.detect{|season| season.year == year}
    season ? season : PGATourReader::PGA_Tour_Scraper.new(year).season
  end

  def self.get_tournaments_by_month(month_number, year = Time.now.strftime("%Y"))
    season = self.get_season_by_year(year)
    if season
      season.tournaments.select {|tournament| tournament.start_date.month == month_number.to_i || tournament.end_date.month == month_number.to_i}
    else
      puts ""
      puts "------------------------------------------------------------"
      puts "I don't have the #{year} season on file let me load the data"
      puts "------------------------------------------------------------"
      puts ""
      PGATourReader::PGA_Tour_Scraper.new(year)
      self.get_tournaments_by_month(month_number, year)
    end
  end

  def self.get_tournament(date, year = Time.now.strftime("%Y"))
    dates = date.split("/")
    puts ""
    puts "your requested date is: #{dates[0]}, #{dates[1]}, #{year}"
    puts ""
    if Date.valid_date?(year.to_i, dates[0].to_i, dates[1].to_i)
      tournament_date = Date.new(year.to_i, dates[0].to_i, dates[1].to_i)
      got_tournament = self.get_tournaments_by_month(dates[0]).detect do |tournament|
        (tournament_date <=> tournament.start_date) > -1 && (tournament_date <=> tournament.end_date) < 1
      end
    else
      puts "that date is invalid, make sure to use the format of mm/dd"
    end
  end
end

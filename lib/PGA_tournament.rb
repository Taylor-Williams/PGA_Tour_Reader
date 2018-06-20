class PGA_Tournament

  attr_accessor :start_date, :end_date, :purse, :name, :location, :winner, :cup_points, :url

  @@all = []

  def initialize(start_date, end_date, attributes = {})
    @start_date = start_date
    @end_date = end_date
    attributes.each {|key, value| self.send("#{key}=", value)}
    save
  end

  def self.all
    @@all
  end

  def save
    self.class.all << self
  end

end

class PGA_Tournament

  attr_accessor :start_date, :end_date, :purse, :name, :location, :winner, :cup_points, :url, :course

  @@all = []

  def initialize(start_date, end_date, attributes = {})
    @start_date = start_date
    @end_date = end_date
    self.add_attributes(attributes)
    save
  end

  def self.all
    @@all
  end

  def add_attributes(attributes)
    attributes.each {|key, value| self.send("#{key}=", value)} unless attributes.empty?
  end

  def save
    self.class.all << self
  end

end

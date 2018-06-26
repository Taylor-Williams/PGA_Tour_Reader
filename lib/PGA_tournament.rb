class PGA_Tournament

  attr_accessor :start_date, :end_date, :attributes, :purse, :name, :location, :winner, :cup_points, :url, :course, :winnings

  def initialize(start_date, end_date, attributes = {})
    @start_date = start_date
    @end_date = end_date
    self.add_attributes(attributes)
  end

  #accepts hash of many tournament attributes and assigns them to self
  def add_attributes(attributes)
    @attributes = attributes
    attributes.each {|key, value| self.send("#{key}=", value)}
  end

  #prints all attributes self has
  def print_attributes
    @attributes.each{|attribute, value| puts "#{attribute}: #{value}"}
  end

  def get_attribute(attribute)
    @attributes.contain?(attribute) ? @attributes[:attribute.to_s] : puts "that is not a valid attribute"
  end

  def list_attributes
    @attributes.keys[0..-2].each{|a| print "#{a}, "}
    puts attributes.keys.last
  end

  def save
    self.class.all << self
  end

  #prints basic information about self in (2/2 - 2/6: Greenbriar Tournament) format
  def print_date_name()
      puts "#{self.start_date} - #{self.end_date}: #{self.name}"
  end

end

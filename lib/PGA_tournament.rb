class PGATourReader::PGA_Tournament

  attr_accessor :start_date, :end_date, :season, :attributes, :purse, :name, :location, :winner, :cup_points, :url, :course, :winnings

  def initialize(start_date, end_date, season, attributes = {})
    @start_date = start_date
    @end_date = end_date
    @season = season
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

  #gets a single attribute's value
  def get_attribute(attribute)
    request = is_attribute?(attribute)
    if request
      puts "#{request} : #{@attributes[request]}"
    end
  end

  #checks to see if attribute this tournament contains and returns attributes' symbol
  def is_attribute?(attribute)
    @attributes.keys.detect{|key| key.to_s == attribute}
  end

  #lists all attributes self has
  def list_attributes
    puts ""
    @attributes.keys[0..-2].each{|a| print "#{a}, "}
    puts attributes.keys.last
  end

  #prints basic information about self in "2/2 - 2/6: Greenbriar Classic" format
  def print_date_name()
      puts "#{self.start_date} - #{self.end_date}: #{self.name}"
  end

end

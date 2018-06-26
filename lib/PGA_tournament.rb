class PGA_Tournament

  attr_accessor :start_date, :end_date, :purse, :name, :location, :winner, :cup_points, :url, :course, :winnings

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
    attributes.each {|key, value| self.send("#{key}=", value)}
  end

  def list_attributes
    puts "the location of the tournament was #{@location}"
    @url? url = @url : url = "not available"
    puts "the url for the tournament is #{url}"
    puts "the course name is #{@course}"
    puts "the total purse of the tournament was #{@purse}"
    puts "the winner of the tournament was #{@winner}"
    puts "#{@winner} got #{@cup_points} fedex cup points and won #{@winnings}"
  end

  def save
    self.class.all << self
  end

  def list_date_name()
      puts "#{self.start_date} - #{self.end_date}, #{self.name}"
  end

end

class PGA_Tournament

  attr_accessor :start_date, :end_date, :purse, :name, :location, :winner, :cup_points, :url

  def initialize(start_date, end_date, attributes = nil)
    @start_date = start_date
    @end_date = end_date
    attributes.each do {|key, value| self.send("#{key}=", value)}
  end

end

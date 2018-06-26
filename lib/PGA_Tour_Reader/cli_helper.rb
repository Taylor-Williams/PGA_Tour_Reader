class PGATourReader::CLI_Helper

  def self.is_month_day?(request)
    date = request.split("/") if /\d\d?\/\d\d?/ =~ request
    date[0].to_i.between?(1,12) && date[1].to_i.between?(1,31) if date
  end

  def self.is_month?(request)
    /\d\d?/ =~ request && request.to_i.between?(1,12)
  end

end

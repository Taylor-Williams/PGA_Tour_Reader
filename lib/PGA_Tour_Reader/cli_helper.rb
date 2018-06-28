class PGATourReader::CLI_Helper

  def self.is_month_day?(request)
    date = request.split("/") if /\A\d\d?\/\d\d?\z/ =~ request
    date[0].to_i.between?(1,12) && date[1].to_i.between?(1,31) if date
  end

  def self.is_month?(request)
    /\A\d\d?\z/ =~ request && request.to_i.between?(1,12)
  end

  def self.select_tournament(tournament)
    if tournament
      puts "you have selected the following tournament:"
      puts ""
      tournament.print_date_name
      puts ""
      puts "If you want a specific attribute type one of the below:"
      tournament.list_attributes
      puts ""
      puts "If you want a list of all the information type \"list\""
      puts "If you want to exit this menu type \"exit\""
      puts ""
      input = gets.strip.downcase
      unless input == "exit"
        case
        when input == "list"
          puts ""
          tournament.print_attributes
          puts ""
        when tournament.is_attribute?(input)
          puts ""
          tournament.get_attribute(input)
          puts ""
        else
          puts "please list a valid attribute or type \"list\" or \"exit\""
        end
        self.select_tournament(tournament)
      end
    else
      puts "you didn't input the date of an official PGA tournament"
    end
  end
end

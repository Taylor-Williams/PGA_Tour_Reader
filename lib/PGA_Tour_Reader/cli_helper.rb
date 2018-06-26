class PGATourReader::CLI_Helper

  def self.is_month_day?(request)
    date = request.split("/") if /\d\d?\/\d\d?/ =~ request
    date[0].to_i.between?(1,12) && date[1].to_i.between?(1,31) if date
  end

  def self.is_month?(request)
    /\d\d?/ =~ request && request.to_i.between?(1,12)
  end

  def self.select_tournament(tournament)
    if tournament
      puts "you have selected the following tournament:"
      tournament.print_date_name
      puts "here is the extra information I have about that tournament:"
      tournament.list_attributes
      puts "If you want a specific attribute type one of the above"
      puts "If you want a list of all the information type \"list\""
      puts "If you want to exit this menu type \"exit\""
      input = gets.strip.downcase
      puts tournament.is_attribute?(input)
      unless input == "exit"
        case input
        when "list"
          tournament.print_attributes
        when tournament.is_attribute?(input)
          tournament.get_attribute(input)
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

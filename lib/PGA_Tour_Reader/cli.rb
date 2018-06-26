#CLI Controller
#supposed to ask for and recieve input
class PGATourReader::CLI

  def call
    # puts some intro
    # asks what info they want
    # listens to a reponse
    # scrapes the data they want
    # loops the response til they are done
    prompt
  end

  def prompt
    puts "current date is #{Time.now.strftime("%Y/%m/%d")} in yyyy/mm/dd"
    # this is to remind the user of nearby weekend dates or to help them
    # think of a month to request data for
    # also gives me some practice with Time B)
    puts "say \"list\" to list all the tournaments for the current PGA Tour season"
    #https://www.pgatour.com/tournaments/schedule.html
    puts "for all the tournaments of a specific month type the month number (1-12)"
    puts "for a specific tournament list any date it was played (mm/dd)"
    puts "say \"exit\" to quit from PGA_Tour_Reader"
    get_requested_info(gets.strip.downcase)
  end

  def get_requested_info(request)
    unless request == "exit"
      case
      when request == "list"
        PGA_Tour_Scraper.new()
        PGA_Season.all.first.list_all_for_season
      when PGATourReader::CLI_Helper.is_month_day?(request)
        PGATourReader::CLI_Helper.select_tournament(PGA_Season.get_tournament(request))
      when PGATourReader::CLI_Helper.is_month?(request)
        PGA_Season.get_tournaments_by_month(request).each{|tournament| tournament.print_date_name}
      else
        puts "i'm not sure what you said can you please give me a request in the"
        puts "format requested, case insensitive"
      end
      prompt
    end
  end

end

#CLI Controller
#supposed to ask for and recieve input

class PGATourReader::CLI

  def call
    # puts some intro
    # asks what info they want
    # listens to a reponse
    # scrapes the data they want
    # loops the response til they are done
    # blah = PGA_Tour_Scraper.new
    prompt
  end

  def prompt
    puts "current date is 20#{Time.now.strftime("%y/%m/%d")} in yyyy/mm/dd"
    # this is to remind the user of nearby weekend dates or to help them
    # think of a month to request data for
    # also gives me some practice with Time B)
    puts "say \"list\" to list all the tournaments for the current PGA Tour season"
    #https://www.pgatour.com/tournaments/schedule.html
    puts "for all the tournaments of a specific month type the month number (0-12)"
    puts "for a specific tournament list the tournament date (mm/dd)"
    puts "say \"exit\" to quit"
    get_requested_info(gets.strip.downcase)
  end

  def get_requested_info(request)
    unless request == "exit"
      case request
      when "list"
        PGA_Tour_Scraper.new()
        PGA_Season.all.first.list_dates_names
      when "month"
        puts "some month"
      when "specific tournament"
        puts "getting_tournament_information"
      else
        puts "i'm not sure what you said can you please give me a request in the"
        puts "format requested, case insensitive"
      end
      prompt
    end
  end

end

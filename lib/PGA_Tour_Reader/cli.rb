#CLI Controller
#supposed to ask for and recieve input

class PGATourReader::CLI

  def call
    # puts some intro
    # asks what info they want
    # listens to a reponse
    # scrapes the data they want
    # loops the response til they are done
    list_tournaments

  end

  def list_tournaments
    puts "current date is 20#{Time.now.strftime("%y/%m/%d")} in yyyy/mm/dd"
    puts "say \"list\" to list all the tournaments for the current PGA Tour season"
    #https://www.pgatour.com/tournaments/schedule.html
    puts "for \"all\" the tournaments for a specific month please list the month"
    puts "for a specific tournament list the tournament name or date"
    puts "say \"exit\" to quit"
    get_tournaments(gets.strip.downcase)
  end

  def get_tournaments(response)
    unless response == "exit"
      case response
      when "list"
        puts "OCT 5 - 8"
        puts "OCT 12 - 15"
        puts "OCT 19 - 22"
        puts "OCT 26 - 29"
        puts "OCT 26 - 29"
        puts "NOV 2 - 5"
        puts "NOV 9 - 12"
        puts "NOV 16 - 19"
      when "month"
        puts "OCT 12 - 15"
        puts "OCT 19 - 22"
        puts "OCT 26 - 29"
        puts "OCT 26 - 29"
      when "specific tournament"
        puts "getting_tournament_information"
      else
        puts "i'm not sure what you said can you please give me a request in the"
        puts "format requested, case insensitive"
      end
      list_tournaments
    end
  end

end

class PGATourReader::CLI

  def call
    puts "Welcome to the PGA Tour Reader!"
    prompt
  end

  def prompt
    puts ""
    puts "say \"list\" to list all the tournaments for the current PGA Tour season"
    puts "for all the tournaments of a specific month type the month number (1-12)"
    puts "for a specific tournament list any date it was played (mm/dd)"
    puts "say \"exit\" to quit from PGA_Tour_Reader"
    puts ""
    get_requested_info(gets.strip.downcase)
  end

  def get_requested_info(request)
    unless request == "exit"
      case
      when request == "list"
        PGATourReader::PGA_Tour_Scraper.new()
        PGATourReader::PGA_Season.get_season_by_year(Time.now.strftime("%Y")).list_all_for_season
      when PGATourReader::CLI_Helper.is_month_day?(request)
        PGATourReader::CLI_Helper.select_tournament(PGATourReader::PGA_Season.get_tournament(request))
      when PGATourReader::CLI_Helper.is_month?(request)
        puts ""
        PGATourReader::PGA_Season.get_tournaments_by_month(request).each{|tournament| tournament.print_date_name}
        puts ""
      else
        puts "I'm not sure what you said can you please give me a"
        puts "request in the format requested, case insensitive."
      end
      prompt
    end
  end

end

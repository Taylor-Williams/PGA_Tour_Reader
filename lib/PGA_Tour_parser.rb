require 'date'

module PGA_Tour_Parser

  #returns array of 2 dates, start at [0] end at [1]
  def date_parser(month, days)
    if /\d/ =~ month #when tourny weekend spans end of month
      start_date = Date.parse("#{month} #{@year}")
      end_date = Date.parse("#{days} #{@year}")
    else #when tourny weekend starts and ends same month
      days = days.split(" - ")
      start_date = Date.parse("#{month} #{days[0]} #{@year}")
      end_date = Date.parse("#{month} #{days[1]} #{@year}")
    end
    [set_year(start_date), set_year(end_date)]
  end

  #corrects the year for tournaments at the beginning of season
  def set_year(date)
    date.month.between?(10,12) ? date << 12 : date #new seasons start in oct (month 10)
  end

  #retuns hash of name, course, location (always) and purse, url if available
  def attribute_parser(tournament_info)
    attribute_text = tournament_info.children[4].text.split(/\s{2,}/)
    attribute_text.shift
    attributes = {
      :name => tournament_info.children[1].children[0].text,
      :url => url_parser(tournament_info),
      :course => attribute_text[0].split(",")[0],
      :location => "#{attribute_text[1]}#{attribute_text[2]}"[0..-2]
    }
    attributes[:purse] = "#{attribute_text[3].split(":")[1].strip}" if attribute_text.length == 4
    attributes
  end

  #returns standardized url (if there is one) into https:// format
  def url_parser(tournament_info)
    url = tournament_info.children[1].attributes["href"]
    if url
      url.value.start_with?("/") ? url = "https://www.pgatour.com#{url.value}" : url = url.value
    end
  end

end

require_relative 'average.rb'

class Parser

  def initialize
    @h = Hash.new
    @average = Average.new
  end

  def parse(html_data)
    if !html_data.index("50 items").nil?
      @h["size"] = Array.new
    else  
      html_data.gsub! '&quot;', '"'
      html_data.gsub! '&amp;', '&'
      while true do
        line = findPieceOfString(html_data,"<tr ","</tr>")
        folder = findPieceOfString(line,"<a href=\"","\">folder</a>")
        if folder.nil?
          title = findPieceOfString(line,"<b>","</b>")
          if !title.nil? && findPieceOfString(line,"<i>","</i>") != "Recording" && !line[":80/images/suggestion-recording.png"]
            if @h["title"].nil?
              @h["title"] = Array.new
              @h["description"] = Array.new
              @h["channels"] = Array.new
              @h["size"] = Array.new
            end
            @h["title"] << title
            @h["description"] << findPieceOfString(line,"<br>","</td>")
            channel =  findPieceOfString(line,"alt=\"","\">")
            @h["channels"] << channel
            addSizeOfRecording(line, channel)
          end # if !title.nil
        else
          if !line[":80/images/suggestions-in-progress-folder.png"]
            if @h["folders"].nil?
              @h["folders"] = Array.new
            end
            @h["folders"] << folder
          end
        end
        html_data = html_data[html_data.index("</tr>")+5..-1]
        if html_data.index("</tr>").nil?
          break;
        end
      end # while true do
    end # else
    @h
  end # parse method

  def findPieceOfString(string,b,e)
    if (string.index(b).nil? || string.index(e).nil?)
      result = nil
    else
      result = string[(string.index(b)+b.bytesize)..(string.index(e, string.index(b))-1)]
    end
    result
  end

  def addSizeOfRecording(line, channel)
    center_align="<td align=\"center\" valign=\"top\" nowrap>"
    trim = line[(line.index(center_align)+center_align.bytesize)..-1]
    #not currently needed, may need for UI later.
    #date = findPieceOfString(trim,"<br>","</td>")
    trim = trim[(trim.index("</td>")+"</td>".bytesize)..-1]
    time = findPieceOfString(trim,center_align,"<br>")
    trim = trim[(trim.index(time)+time.bytesize)..-1]
    size = findPieceOfString(trim,"<br>","</td>")
    @average.calculate(time,size,channel)
    if size["MB"]
      size = size.to_f/1024.0
    else
      size = size.to_f
    end
    @h["size"] << size
  end
end

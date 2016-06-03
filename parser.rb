class Parser

  def initialize
    @h = Hash.new
  end

  def parse(html_data)
    baseFolderName="https://192.168.50.146/nowplaying/"
    html_data.gsub! '&quot;', '"'
    html_data.gsub! '&amp;', '&'
    while true do
      line = findPieceOfString(html_data,"<tr ","</tr>")
      folder = findPieceOfString(line,"<a href=\"","\">folder</a>")
      if folder.nil?
        title = findPieceOfString(line,"<b>","</b>")
        if !title.nil?
          if @h["title"].nil?
            @h["title"] = Array.new
            @h["description"] = Array.new
          end
          @h["title"] << title
          @h["description"] << findPieceOfString(line,"<br>","</td>")
        end # if !title.nil
      else # if folder.nil
        if @h["folders"].nil?
          @h["folders"] = Array.new
        end
        @h["folders"] << baseFolderName+folder
      end
      html_data = html_data[html_data.index("</tr>")+5..-1]
      if html_data.index("</tr>").nil?
        break;
      end
    end # while true do
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
end

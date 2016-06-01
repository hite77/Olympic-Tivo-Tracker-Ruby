class Parser

  def initialize
    @h = Hash.new
  end

  def parse(html_data)
    counter = 0
    html_data.gsub! '&quot;', '"'
    while true do
      line = findPieceOfString(html_data,"<tr ","</tr>")
      html_data = html_data[html_data.index("</tr>")+5..-1]
      if html_data.index("</tr>").nil?
        break;
      end
      folder = findPieceOfString(line,"<a href=\"","\">folder</a>")
      if folder.nil?
        title = findPieceOfString(line,"<b>","</b>")
        if !title.nil?
          @h[counter] = Hash.new
          @h[counter]["title"] = title
          counter = counter + 1
        end
      end
    end
    @h
  end
  
  def findPieceOfString(string,b,e)
    if (string.index(b).nil? || string.index(e).nil?)
      result = nil
    else
      result = string[(string.index(b)+b.bytesize)..(string.index(e)-1)]
    end
    result
  end
end

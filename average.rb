require 'json'

class Average
 def initialize
    @h = Hash.new
    if File.exist?("averages.json")
      @h = JSON.parse(File.read('averages.json'))
    end
 end

 def retrieve(channel)
   lookup = @h[channel]
   if (lookup.nil?)
     lookup = @h.values.inject{ |sum, el| sum + el }.to_f / @h.values.size
   end
   lookup
 end

 def calculate(time, size, channel)
   splits = time.split(":")
   hours = splits[0].to_f
   minutes = splits[1].to_f
   seconds = splits[2].to_f
   if size.index("MB").nil?
     size_gb = size.delete( "GB" ).to_f
   else
     size_gb = size.delete( "MB" ).to_f/1024.0
   end
   average= size_gb/(hours+minutes/60.0+seconds/(60.0*60.0))
   @h[channel] = average
   File.open('averages.json', 'w') { |fo| fo.puts @h.to_json }
   average
 end
end

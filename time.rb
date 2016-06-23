class Timer
require 'time'
require 'csv'

  def initialize
    t = Time.now
    File.open('output.txt', 'w') {}
    recordings = CSV.read("test.csv", converters: :numeric)
    recordings = recordings[2..-1]
    recordings.each { |item|
      recording_time_start = convert(item,0)
      recording_time_end = convert(item,2)
      channel = item[4]
      if t.between?(recording_time_start, recording_time_end)
        hours = (t-recording_time_start)/60/60
        open('output.txt', 'a') { |f|
  	  f.puts "#{channel} -- Recording -- ending at #{recording_time_end}:#{hours} hours"
	}
      end
    }
  end

  def convert(item,start_index)
     hour = item[start_index+1].split(":")[0].to_i
     minute = item[start_index+1].split(":")[1].to_i
     if (item[start_index+1].split(" ")[1] == "PM")
       hour = hour + 12
     end
     year = item[start_index].split("/")[0].to_i
     month = item[start_index].split("/")[1].to_i
     day = item[start_index].split("/")[2].to_i
     Time.new(year,month,day,hour,minute)
  end
end

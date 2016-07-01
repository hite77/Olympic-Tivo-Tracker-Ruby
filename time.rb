require 'time'
require 'csv'
require_relative 'average.rb'

class Timer

  def calculate
    t = Time.now
    File.open('output.txt', 'w') {}
    recordings = CSV.read("test.csv", converters: :numeric)
    recordings = recordings[2..-1]
    averager = Average.new
    current_total = 0.0 ##todo refactor name
    total_projected_gb = 0.0
    recordings.each { |item|
      recording_time_start = convert(item,0)
      recording_time_end = convert(item,2)
      channel = item[4]
      gb_per_hour = averager.retrieve(channel)
      if t < recording_time_start
        total_projected_gb += (recording_time_end-recording_time_start)/60/60*gb_per_hour
      elsif t.between?(recording_time_start, recording_time_end)
        hours = (t-recording_time_start)/60/60
        total_projected_gb += (recording_time_end-t)/60/60*gb_per_hour
        current_total +=  hours * gb_per_hour
        open('output.txt', 'a') { |f|
  	  f.puts "#{channel} -- Recording -- ending at #{recording_time_end}:#{hours} hours"
	}
      end
    }
    {"current_recording_gb" => current_total.round(2), "projected_recording_gb" => total_projected_gb.round(2)}
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

require 'time'
require 'csv'
require_relative 'average.rb'
require 'json'

class Timer

  def initialize
    @result = {}
    @result.default = 0
  end

  def calculate
    t = Time.now
    last_run = []
    this_run = []
    File.open('output.txt').each do |line|
      line = line.split("-0400:")[0]
      last_run << line
    end
    File.open('output.txt', 'w') {}
    recordings = CSV.read("test.csv", converters: :numeric)
    recordings = recordings[2..-1]
    averager = Average.new
    recordings.each { |item|
      recording_time_start = convert_string_time_to_time(item,0)
      recording_time_end = convert_string_time_to_time(item,2)
      channel = item[4]
      gb_per_hour = averager.retrieve(channel)
      if t < recording_time_start
        time_in_seconds = (recording_time_end-recording_time_start)
        @result["projected_recording_seconds"] += time_in_seconds
        @result["projected_recording_gb"] += (time_in_seconds)/60/60*gb_per_hour
      elsif t.between?(recording_time_start, recording_time_end)
        hours = (t-recording_time_start)/60/60
        time_in_seconds = (recording_time_end-t)
        @result["projected_recording_gb"] += time_in_seconds/60/60*gb_per_hour
        @result["projected_recording_seconds"] += time_in_seconds
        @result["current_recording_gb"] += hours * gb_per_hour
        hours = hours.round(2)
        open('output.txt', 'a') { |f|
          line = "#{channel} -- Recording -- ending at #{recording_time_end}:#{hours} hours"
  	  f.puts line
          this_run << line.split("-0400:")[0]
	}
      end
    }
    @result["projected_recording_gb"] = @result["projected_recording_gb"].round(2)
    @result["current_recording_gb"] = @result["current_recording_gb"].round(2)
    update = false
    if File.exist?("lastupdate.json")
      last_update = JSON.parse(File.read('lastupdate.json'))
      if t-Time.parse(last_update["last_update"]) > 15*60
        update = true
      end
    else
      update = true
    end
    if (!(last_run == this_run) or update)
	@result["perform_update"] = true
        last_update = {}
        last_update["last_update"] = t
        File.open('lastupdate.json', 'w') { |fo| fo.puts last_update.to_json }
    else
        @result["perform_update"] = false
    end
    @result
  end

  def convert_string_time_to_time(item,start_index)
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

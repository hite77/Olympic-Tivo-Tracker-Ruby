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
    if File.exist?("recording_status.txt")
      File.open('recording_status.txt').each do |line|
        last_run << line.strip
      end
    end
    File.open('recording_status.txt', 'w') {}
    File.open('output.txt', 'w') {}
    recordings = CSV.read("test.csv", converters: :numeric)
    recordings = recordings[2..-1]
    averager = Average.new
    recordings.each { |item|
      recording_time_start = convert_string_time_to_time(item,0)
      recording_time_end = convert_string_time_to_time(item,2)
      channel = item[4]
      gb_per_hour = averager.retrieve(channel)
      full_size_of_recording_in_gb = (recording_time_end-recording_time_start)/60/60*gb_per_hour
      if t < recording_time_start
        time_in_seconds = (recording_time_end-recording_time_start)
        @result["projected_recording_seconds"] += time_in_seconds
        @result["projected_recording_gb"] += full_size_of_recording_in_gb
      elsif t.between?(recording_time_start, recording_time_end)
        time_left_in_seconds = (recording_time_end-t)
	@result["projected_recording_gb"] += full_size_of_recording_in_gb
        @result["projected_recording_seconds"] += time_left_in_seconds
        @result["current_recording_gb"] += full_size_of_recording_in_gb
        open('output.txt', 'a') { |f|
          line = "#{channel} -- Recording -- ending at #{recording_time_end}:#{Time.at(time_left_in_seconds).utc.strftime('%H:%M:%S')} left"
	  f.puts line
          this_run << line.split("-0400:")[0].strip
	}
        open('recording_status.txt', 'a') { |f| f.puts "#{channel} -- Recording -- ending at #{recording_time_end}:cut".split("-0400:")[0].strip }
      end
    }
    @result["projected_recording_gb"] = @result["projected_recording_gb"].round(2)
    @result["current_recording_gb"] = @result["current_recording_gb"].round(2)
    update_when_results_change_or_fifteen_minutes_pass(t, !(last_run==this_run))
    @result
  end

  def update_when_results_change_or_fifteen_minutes_pass(current_time, difference_in_runs)
    update = true
    if File.exist?("lastupdate.json")
      last_update = JSON.parse(File.read('lastupdate.json'))
      if current_time-Time.parse(last_update["last_update"]) < 15*60
        update = false
      end
    end
    if (difference_in_runs or update)
	@result["perform_update"] = true
        File.open('lastupdate.json', 'w') { |fo| fo.puts Hash["last_update",current_time].to_json }
    else
        @result["perform_update"] = false
    end
  end

  def convert_string_time_to_time(item,start_index)
     Time.parse(item[start_index].to_s+" "+item[start_index+1].to_s)
  end
end

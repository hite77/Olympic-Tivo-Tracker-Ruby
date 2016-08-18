#!/usr/bin/ruby -w
require_relative 'parser.rb'
require_relative 'time.rb'

@lastdata = {}
@current_recording_gb
@projected_recording_gb
@projected_recording_seconds
@password=`cat pass.txt`.chomp

def update
  data = Timer.new.calculate
  @todo_items_recorded=data["todo_recorded"]
  @current_recording_gb=data["current_recording_gb"]
  @projected_recording_gb=data["projected_recording_gb"]
  @projected_recording_seconds=data["projected_recording_seconds"]
  if data["perform_update"]
    open('output.txt', 'a') { |f| f.puts "Updating at:"+Time.now.to_s}
    @lastdata=update_data(@password)
    File.open('tivo_contents.json', 'w') { |fo| fo.puts @lastdata.to_json }
  else
    @lastdata=JSON.parse(File.read('tivo_contents.json'))
  end
end

def update_data(password)
  parser = Parser.new

  data = parser.parse(`curl --digest -k "https://tivo:#{password}@192.168.50.146/nowplaying/index.html"`)
  if !data["folders"].nil?
    data["folders"].each { |folder| data = parser.parse(`curl --digest -k "https://tivo:#{password}@192.168.50.146/nowplaying/#{folder}"`) }
  end
  data
end

update

size_in_gb_hard_drive=1823.17755681818

open('output.txt', 'a') { |f|
sizes = @lastdata["size"]
total =  sizes.inject(0.0){|sum,x| sum + x }+@current_recording_gb
f.puts "total"
f.puts total
f.puts "percent external drive"
partial_round = (total / size_in_gb_hard_drive * 100.0).round(1)
f.puts partial_round
#f.puts (total / 884.1460701 * 100.0)#.round(0)
f.puts "percent"
f.puts partial_round.round(0)
projected_size = total + @projected_recording_gb
f.puts "projected total"
f.puts projected_size
f.puts "percent projected"
f.puts (projected_size / size_in_gb_hard_drive * 100.0)#.round(0)
f.puts "Projected time"
hours = (@projected_recording_seconds/60.0/60.0).floor
minutes = ((@projected_recording_seconds-hours*60.0*60.0)/60.0).floor
seconds = (@projected_recording_seconds-hours*60.0*60.0-minutes*60.0).floor
f.puts "#{hours}:#{minutes}:#{seconds}"
f.puts "Recorded todo items left"
f.puts  @todo_items_recorded
}

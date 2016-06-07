#!/usr/bin/ruby -w
require_relative "parser.rb"

password=`cat pass.txt`.chomp

parser = Parser.new
first_run = parser.parse(`curl --digest -k "https://tivo:#{password}@192.168.50.146/nowplaying/index.html"`)
#puts first_run["folders"]

#data = parser.parse(`curl --digest -k "https://tivo:#{password}@192.168.50.146/nowplaying/TiVoConnect?Command=QueryContainer&Container=%2FNowPlaying%2F17%2F1686382"`)

data = {}
first_run["folders"].each { |x| puts x; data = parser.parse(`curl --digest -k "https://tivo:#{password}@192.168.50.146/nowplaying/#{x}"`) }

#first_run["folders"].inject(){|folder| data = parser.parse(`curl --digest -k "https://tivo:#{password}@192.168.50.146/nowplaying/#{folder}"`) }

puts data["title"]
sizes = data["size"]
puts sizes.inject(0.0){|sum,x| sum + x }

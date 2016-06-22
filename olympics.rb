#!/usr/bin/ruby -w
require_relative "parser.rb"

password=`cat pass.txt`.chomp

parser = Parser.new
first_run = parser.parse(`curl --digest -k "https://tivo:#{password}@192.168.50.146/nowplaying/index.html"`)

data = {}
first_run["folders"].each { |folder| data = parser.parse(`curl --digest -k "https://tivo:#{password}@192.168.50.146/nowplaying/#{folder}"`) }

puts data["title"]
sizes = data["size"]
total =  sizes.inject(0.0){|sum,x| sum + x }
puts "total"
puts total
puts "percent no external drive"
puts total / 884.1460701 * 100.0

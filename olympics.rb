#!/usr/bin/ruby -w
password=`cat pass.txt`.chomp
puts `curl --digest -k "https://tivo:#{password}@192.168.50.146/nowplaying/index.html"`

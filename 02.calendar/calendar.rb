require 'date'
require 'optparse'
input = ARGV.getopts("y:", "m:")

year = Date.today.year
month = Date.today.mon
year = input["y"].to_i if input["y"]
month = input["m"].to_i if input["m"]

title = "#{year}年#{month}月"
firstday_dow = Date.new(year,month,1).wday
week = ["日","月","火","水","木","金","土"]

puts title.center(20)
puts week.join(" ")
print "   " * firstday_dow

(Date.new(year,month,1)..Date.new(year,month,-1)).each do |date|
  print date.day.to_s.rjust(2) + " "
  puts if date.wday == 6
end
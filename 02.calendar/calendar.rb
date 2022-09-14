require 'date'
require 'optparse'

year_def = Date.today.year
month_def = Date.today.mon

input = ARGV.getopts("y:", "m:")

if input["y"]
  year = input["y"].to_i
else
  year = year_def
end

if input["m"]
  month = input["m"].to_i
else
  month = month_def
end

title = "#{year}年#{month}月"
first_day_of_month = Date.new(year,month,1)
first_date = first_day_of_month.day
last_date = Date.new(year,month,-1).day
firstday_dow = first_day_of_month.wday
week = ["日","月","火","水","木","金","土"]

puts title.center(20)
puts week.join(" ")
print "   " * firstday_dow

dow = firstday_dow
(1..last_date).each do |date|
  print date.to_s.rjust(2) + " "
  dow = dow + 1
  puts if dow % 7 == 0    #土曜日(7の倍数)で改行
end
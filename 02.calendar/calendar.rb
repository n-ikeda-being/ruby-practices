require 'date'
require 'optparse'

year_today = Date.today.year
month_today = Date.today.mon

input = ARGV.getopts("y:", "m:")

year =
  if input["y"]
    input["y"].to_i
  else
    year_today
  end

month =
if input["m"]
  input["m"].to_i
else
  month_today
end

title = "#{year}年#{month}月"
first_date = Date.new(year,month,1).day
last_date = Date.new(year,month,-1).day
firstday_dow = Date.new(year,month,1).wday
week = ["日","月","火","水","木","金","土"]

puts title.center(20)
puts week.join(" ")
print "   " * firstday_dow

wday = firstday_dow
(first_date..last_date).each do |date|
  print date.to_s.rjust(2) + " "
  wday = wday + 1
  if wday % 7 == 0    #土曜日(7の倍数)で改行
    puts
  end
end
if wday % 7 != 0
  puts
end
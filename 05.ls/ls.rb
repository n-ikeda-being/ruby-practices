# /usr/bin/env ruby
# frozen_string_literal: true

require 'debug'

OUTPUT_COLUMN = 3

def current_date
  Dir.glob('*')
end

def lswork(column, date)
  #  binding.break
  date = date_arrangement(column, date)
  date.each do |num|
    puts num.join('  ')
  end
end

def date_arrangement(column, date)
  ascending_order_date = date.sort # 昇順に並び替え
  ascending_order_date_group = ascending_order_date.each_slice(OUTPUT_COLUMN)
end

lswork(OUTPUT_COLUMN, current_date)

#!/usr/bin/env ruby
# frozen_string_literal: true

file_name = Dir.glob('*')

COLUMN = 3
SPACE = 15

def all_files(file_name)
  all_file_quantity = file_name.size.to_f  #全部のファイル数
  line = (all_file_quantity / COLUMN).ceil #全部のファイル数 ÷ 指定した行数 = 縦の列数 .ceil:切り上げ
  split_files = file_name.each_slice(line) #全部のファイル数を縦の列数数で分ける

  line.times do |i|
    split_files.each do |files|
      print files[i].ljust(SPACE) unless files[i].nil?
    end
    puts
  end
end

all_files(file_name)
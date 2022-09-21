#!/usr/bin/env ruby
# frozen_string_literal: true

all_files = Dir.glob('*')

MAX_COLUMN = 3
SHOW_FILE_SPACE = 3

def main(all_files)
  row = row(all_files)
  max_word_file = max_file_size(all_files)
  splitted_files = split_file(all_files, row)
  output(row, max_word_file, splitted_files)
end

def row(all_files)
  all_file_quantity = all_files.size
  (all_file_quantity.to_f / MAX_COLUMN).ceil
end

def max_file_size(all_files)
  all_files.map(&:length).max
end

def split_file(all_files, row)
  all_files.each_slice(row).map{|arr| p arr}
end

def output(row, max_word_file, splitted_files)
  row.times do |i|
    splitted_files.each do |files|
      print files[i].ljust(max_word_file + SHOW_FILE_SPACE) unless files[i].nil?
    end
    puts
  end
end

main(all_files)

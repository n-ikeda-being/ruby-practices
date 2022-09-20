#!/usr/bin/env ruby
# frozen_string_literal: true

all_files = Dir.glob('*')

COLUMN = 3
SPACE = 3

def main(all_files)
  line = line(all_files)
  max_word_file = max_file(all_files)
  split_files = split_file(all_files, line)
  output(line, max_word_file, split_files)
end

def line(all_files)
  all_file_quantity = all_files.size
  (all_file_quantity.to_f / COLUMN).ceil
end

def max_file(all_files)
  all_files.map(&:length).max
end

def split_file(all_files, line)
  all_files.each_slice(line)
end

def output(line, max_word_file, split_files)
  line.times do |i|
    split_files.each do |files|
      print files[i].ljust(max_word_file + SPACE) unless files[i].nil?
    end
    puts
  end
end

main(all_files)

# frozen_string_literal: true

require 'optparse'

def main
  options = parse_options
  if ARGV.empty?
    input_data = $stdin.readlines
    name = nil
    output_data(count_line(input_data), count_word(input_data), count_size(input_data), name, options)
  else
    output_arvg_is_not_empty(ARGV, options)
  end
end

def parse_options
  options = {}
  OptionParser.new do |opt|
    opt.on('-l') { |v| options[:l] = v }
    opt.on('-w') { |v| options[:w] = v }
    opt.on('-c') { |v| options[:c] = v }
    opt.parse!(ARGV)
  end
  options
end

def count_line(data)
  data.join.count("\n")
end

def count_word(data)
  data.sum { |line| line.split(/[\s+|"　"]/).size }
end

def count_size(data)
  data.sum(&:bytesize)
end

def has_no_option?(options)
  !options[:l] && !options[:w] && !options[:c]
end

def output_data(line, word, size, name, options)
  print line.to_s.rjust(5) if options[:l] || has_no_option?(options)
  print word.to_s.rjust(5) if options[:w] || has_no_option?(options)
  print size.to_s.rjust(5) if options[:c] || has_no_option?(options)
  puts "  #{name}"
end

def output_arvg_is_not_empty(argv, options)
  argv.each do |file_name|
    input_data = File.readlines(file_name)
    line = count_line(input_data)
    word = count_word(input_data)
    size = count_size(input_data)
    name = file_name
    output_data(line, word, size, name, options)
  end
  total(argv, options) if argv.size > 1
end

def total(argv, options)
  total_line = []
  total_word = []
  total_size = []
  argv.each do |file_name|
    input_data = File.readlines(file_name)
    line = count_line(input_data)
    word = count_word(input_data)
    size = count_size(input_data)
    total_line.push(line)
    total_word.push(word)
    total_size.push(size)
  end
  total_line = total_line.sum
  total_word = total_word.sum
  total_size = total_size.sum
  name = '合計'
  output_data(total_line, total_word, total_size, name, options)
end

main

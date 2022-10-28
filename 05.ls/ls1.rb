# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'date'

all_files = Dir.glob('*')

MAX_NUMBER_OF_COLUMN = 3
BETWEEN_FILES_SPACE = 3

FILE_AUTHORITY = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-',
                   '7' => 'rwx' }.freeze
FILE_TYPE = { '1' => 'p', '2' => 'c', '4' => 'd', '6' => 'b', '10' => '-', '12' => 'l', '14' => 's' }.freeze

USER_AUTHORITY_NUMBER = 2
GROUP_AUTHORITY_NUMBER = 1
OTHER_AUTHORITY_NUMBER = 0

# オプションなし

def main(all_files)
  argv_option = parse_option(ARGV)
  no_option(all_files) unless argv_option[:l]
  l_option(all_files) if argv_option[:l]
end

def parse_option(argv)
  argv_option = {}
  OptionParser.new do |opt|
    opt.on('-l') { |v| argv_option[:l] = v }
    opt.parse!(argv)
  end
  argv_option
end

def no_option(all_files)
  row = row(all_files)
  max_file_size = max_file_size(all_files)
  splitted_files = split_file(all_files, row)
  output(row, max_file_size, splitted_files)
end

def row(all_files)
  all_file_quantity = all_files.size
  (all_file_quantity.to_f / MAX_NUMBER_OF_COLUMN).ceil
end

def max_file_size(all_files)
  all_files.map(&:length).max
end

def split_file(all_files, row)
  all_files.each_slice(row).map
end

def output(row, max_file_size, splitted_files)
  row.times do |i|
    splitted_files.each do |files|
      print files[i].ljust(max_file_size + BETWEEN_FILES_SPACE) unless files[i].nil?
    end
    puts
  end
end

def l_option(all_files)
  all_files.map do |files|
    fs = File.lstat(files)
    octal_file_mode = fs.mode.digits(8)
    octal_file_type = fs.mode.digits(8)[5]
    file_type =
      if octal_file_type == 1
        octal_file_type.to_s + octal_file_mode[4].to_s
      else
        octal_file_mode[4].to_s
      end
    output_file_type = FILE_TYPE[file_type]
    user_authority = FILE_AUTHORITY[octal_file_mode[USER_AUTHORITY_NUMBER].to_s]
    group_authority = FILE_AUTHORITY[octal_file_mode[GROUP_AUTHORITY_NUMBER].to_s]
    other_authority = FILE_AUTHORITY[octal_file_mode[OTHER_AUTHORITY_NUMBER].to_s]

    puts
    print output_file_type.to_s + user_authority.to_s + group_authority.to_s + other_authority.to_s
    print " #{fs.nlink}"
    print " #{Etc.getpwuid(fs.uid).name}"
    print " #{Etc.getgrgid(fs.gid).name}"
    print " #{fs.size.to_s.rjust(5)}"
    print " #{fs.mtime.strftime('%-m月 %d %H:%M')}"
    print " #{files.rjust(5)}"
  end
  puts
end

main(all_files)

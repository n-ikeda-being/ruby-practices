# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'date'

all_files = Dir.glob('*')

opt = OptionParser.new
params = {}
opt.on('-l') { |v| params[:l] = v }
opt.parse!(ARGV)

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

def l_main(all_files)
  loutput(all_files)
end

def loutput(all_files)
  all_files.map do |files|
    fs = File.lstat(files)
    file_type = fs.mode.digits(8)[4].to_s
    file_type = fs.mode.digits(8)[5].to_s + fs.mode.digits(8)[4].to_s if fs.mode.digits(8)[5] == 1
    output_file_type = FILE_TYPE[file_type]
    user_authority = FILE_AUTHORITY[fs.mode.digits(8)[USER_AUTHORITY_NUMBER].to_s]
    group_authority = FILE_AUTHORITY[fs.mode.digits(8)[GROUP_AUTHORITY_NUMBER].to_s]
    other_authority = FILE_AUTHORITY[fs.mode.digits(8)[OTHER_AUTHORITY_NUMBER].to_s]

    puts
    print output_file_type.to_s + user_authority.to_s + group_authority.to_s + other_authority.to_s
    print "  #{fs.nlink}"
    print "  #{Etc.getpwuid(fs.uid).name}"
    print "  #{Etc.getgrgid(fs.gid).name}"
    print "  #{fs.size.to_s.rjust(5)}"
    print "  #{fs.mtime.strftime('%-m月 %d %H:%M')}"
    print "  #{files.rjust(5)}"
  end
  puts
end

l_main(all_files) if params[:l]
main(all_files) unless params[:l]

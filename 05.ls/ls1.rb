# frozen_string_literal: true

require 'optparse'
require 'etc'

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
USER_AUTHORITY = 2
GROUP_AUTHORITY = 1
OTHER_AUTHORITY = 0

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

# Lオプション
def l_main(all_files)
  obj = Main.new
  obj.loutput(all_files)
  obj.file_type
  obj.user_authority
  obj.group_authority
  obj.other_authority
  obj.print_date
end

class Main
  def loutput(all_files)
    all_files.each_slice(1).each do |files|
      fs = File::Stat.new(files[0])
      @file_name = files[0]
      @link = fs.nlink
      @user_name  = Etc.getpwuid(fs.uid).name
      @group_name = Etc.getgrgid(fs.gid).name
      @byte = fs.size.to_s
      @files_mode = fs.mode.digits(8)
      @file_type = @files_mode[4].to_s
      @file_type = @files_mode[5].to_s + @files_mode[4].to_s if @files_mode[5] == 1
      @mtime = fs.mtime.to_a
    end
  end

  def file_type
    @output_file_type = case @file_type
                        when '1'
                          FILE_TYPE.values[0]
                        when '2'
                          FILE_TYPE.values[1]
                        when '4'
                          FILE_TYPE.values[2]
                        when '6'
                          FILE_TYPE.values[3]
                        when '10'
                          FILE_TYPE.values[4]
                        when '12'
                          FILE_TYPE.values[5]
                        when '14'
                          FILE_TYPE.values[6]
                        else
                          '0'
                        end
  end

  def user_authority
    @user_authority = case @files_mode[USER_AUTHORITY]
                      when 0
                        FILE_AUTHORITY.values[0]
                      when 1
                        FILE_AUTHORITY.values[1]
                      when 2
                        FILE_AUTHORITY.values[2]
                      when 3
                        FILE_AUTHORITY.values[3]
                      when 4
                        FILE_AUTHORITY.values[4]
                      when 5
                        FILE_AUTHORITY.values[5]
                      when 6
                        FILE_AUTHORITY.values[6]
                      when 7
                        FILE_AUTHORITY.values[7]
                      else
                        '?'
                      end
  end

  def group_authority
    @group_authority = case @files_mode[GROUP_AUTHORITY]
                       when 0
                         FILE_AUTHORITY.values[0]
                       when 1
                         FILE_AUTHORITY.values[1]
                       when 2
                         FILE_AUTHORITY.values[2]
                       when 3
                         FILE_AUTHORITY.values[3]
                       when 4
                         FILE_AUTHORITY.values[4]
                       when 5
                         FILE_AUTHORITY.values[5]
                       when 6
                         FILE_AUTHORITY.values[6]
                       when 7
                         FILE_AUTHORITY.values[7]
                       else
                         '?'
                       end
  end

  def other_authority
    @other_authority = case @files_mode[OTHER_AUTHORITY]
                       when 0
                         FILE_AUTHORITY.values[0]
                       when 1
                         FILE_AUTHORITY.values[1]
                       when 2
                         FILE_AUTHORITY.values[2]
                       when 3
                         FILE_AUTHORITY.values[3]
                       when 4
                         FILE_AUTHORITY.values[4]
                       when 5
                         FILE_AUTHORITY.values[5]
                       when 6
                         FILE_AUTHORITY.values[6]
                       when 7
                         FILE_AUTHORITY.values[7]
                       else
                         '?'
                       end
  end

  def print_date
    puts '合計：'
    print @output_file_type.to_s + @user_authority.to_s + @group_authority.to_s + @other_authority.to_s
    print " #{@link}"
    print " #{@user_name}"
    print " #{@group_name}"
    print " #{@byte.rjust(5)}"
    print " #{@mtime[4]}"
    print '月'
    print " #{@mtime[3].to_s.rjust(3)}"
    print " #{@mtime[2].to_s.rjust(3)}"
    print ':'
    print @mtime[1].to_s if (@mtime[1]).zero?
    print 0 if @mtime[1] < 10 && @mtime[1] > 1
    print @mtime[1].to_s
    print "  #{@file_name.rjust(5)}"
    puts
  end
end

l_main(all_files) if params[:l]
main(all_files) unless params[:l]

# frozen_string_literal: true

require 'optparse'

def main
  params = ARGV.getopts('lwc')
  file_names = ARGV #入力した場合はARGVに値が入る
  if ARGV.empty?
    name = nil
  end
  files = read_files(file_names) #データ全部取得
  file_data = create_file_data(files, file_names) # 表示用のデータ生成
  total_data = total(file_data, params) # 合計値の計算
  output(file_data, total_data, name, params) # 表示
end

def read_files(file_names)
    file = $stdin.readlines # データ全部取得
    files = [] # 配列作る
    files.push(file) # 配列に格納
end

def without_option(params)
  !params['l'] && !params['w'] && !params['c']
end

def create_file_data(files, file_names)
  file_data =
    files.map do |file|
      file_data = {}
      file_data[:l] = file.map { |lines| lines.count("\n") }.sum # 行数をカウントしてlines変数に格納
      file_data[:w] = file.map { |words| words.split.count }.sum # 単語数をカウントしてwords変数に格納
      file_data[:c] = file.map(&:bytesize).sum # byteで配列にして、中身を全部足す
      name = nil
      file_data
    end
end

def total(file_data, params)
  without_option = without_option(params) # 何のオプションも付いていないとき
  total_data = {}
  total_data[:l] = file_data.map { |data| data[:l] }.sum if params['l'] || without_option # 行数の合計
  total_data[:w] = file_data.map { |data| data[:w] }.sum if params['w'] || without_option # 単語数の合計
  total_data[:c] = file_data.map { |data| data[:c] }.sum if params['c'] || without_option # byteの合計
  total_data
end

def output(file_data, total_data, name, params)
  without_option = without_option(params)
  file_data.each do |data|
    print data[:l].to_s.rjust(10) if params['l'] || without_option
    print data[:w].to_s.rjust(10) if params['w'] || without_option
    print data[:c].to_s.rjust(10) if params['c'] || without_option
    puts " #{name}"
    puts
  end
end

main

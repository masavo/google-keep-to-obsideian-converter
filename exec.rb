require 'nokogiri'
require 'fileutils'
require_relative 'src/file_processor'

class Exec
  attr_reader :src_path, :target_path, :max_files

  def initialize
    @src_path = ARGV[0]
    @target_path = ARGV[1]
    @max_files = ARGV[2].to_i || 100_000_000
  end

  def run
    process_files(fetch_html_files)
  end

  private

  def fetch_html_files
    FileProcessor.fetch_all(src_path, max_files)
  end

  def process_files(html_file_names)
    html_file_names.each do |html_file_name|
      FileProcessor.run(html_file_name, src_path, output_folder)
    end
  end

  def output_folder
    FileProcessor.mkdir(target_path)
  end
end

Exec.new.run

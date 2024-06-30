require 'fileutils'
require_relative 'google_keep_data_parser'
require_relative 'markdown_formatter'
require_relative 'attachment_processor'
require_relative 'file_saver'
require_relative 'progress_notifier'

class FileProcessor
  attr_reader :file_path, :src_path, :folder_name

  def self.run(file_path, src_path, folder_name)
    new(file_path, src_path, folder_name).run
  end

  def initialize(file_path, src_path, folder_name)
    @file_path = file_path
    @src_path = src_path
    @folder_name = folder_name
  end

  def run
    puts @file_path
    data_parser = parse_file
    attachment_processor = process_attachments(data_parser)
    save_markdown(data_parser, attachment_processor)
  end

  private

  def parse_file
    json = File.read(@file_path)
    GoogleKeepDataParser.new(json)
  end

  def process_attachments(data_parser)
    attachment_processor = AttachmentProcessor.new(data_parser.attachments, @src_path, @folder_name)
    attachment_processor.process
    ProgressNotifier.new("Attachments processed and saved.").notify
    attachment_processor
  end

  def save_markdown(data_parser, attachment_processor)
    markdown = MarkdownFormatter.new(data_parser, @folder_name, attachment_processor).to_markdown
    file_saver = FileSaver.new(
      File.join(@folder_name, "#{data_parser.title}.md"),
      markdown,
      data_parser
    )
    file_saver.save
    ProgressNotifier.new("Markdown file saved.").notify
  end

  def self.fetch_all(folder_name, max_files)
    file_names = Dir.glob(File.join(folder_name, '*.json')).first(max_files)
  end

  def self.mkdir(folder_name)
    FileUtils.mkdir_p(folder_name) # 出力フォルダが存在しない場合は作成する
  end
end

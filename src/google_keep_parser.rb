require 'date'
require 'json'

class GoogleKeepParser

  attr_reader :json, :title, :created_at, :updated_at, :content, :labels

  def initialize(json)
    @json = json
    parse
  end

  def parse
    json_data = JSON.parse(json)
    @title = json_data["title"]
    @created_at = Time.at(json_data["createdTimestampUsec"] / 1_000_000).to_datetime.to_s
    @updated_at = Time.at(json_data["userEditedTimestampUsec"] / 1_000_000).to_datetime.to_s
    @content = get_content(json_data)
    @labels = get_labels(json_data)
    @attachments = json_data["attachments"]
  end

  def to_markdown
    markdown_content = <<~MARKDOWN
      ---
      created_at: #{created_at}
      updated_at: #{updated_at}
      ---

      #{labels.map { |label| "##{label}" }.join(' ')}

      #{content}
    MARKDOWN
  end

  def save(output_folder)
    if @attachments
      process_attachments(output_folder)
    else
      save_markdown(output_folder)
    end
  end

  def process_attachments(output_folder)
    @attachments.each do |attachment|
      if attachment["mimetype"].start_with?("image/")
        image_path = File.join(output_folder, "images", attachment["filePath"])
        FileUtils.mkdir_p(File.dirname(image_path))
        FileUtils.cp(attachment["filePath"], image_path)
        set_file_times(image_path)
        notify_progress("Image saved to #{image_path}")
      end
    end
  end

  def save_markdown(output_folder)
    filepath = File.join(output_folder, file_name)
    File.write(filepath, to_markdown)
    set_file_times(filepath)
    notify_progress("Markdown file '#{filepath}' has been created.")
  end

  def set_file_times(filepath)
    created_time = Time.parse(created_at)
    updated_time = updated_at ? Time.parse(updated_at) : created_time
    FileUtils.touch(filepath, mtime: updated_time, atime: created_time)
  end
  private

  def get_labels(json_data)
    arr = json_data["labels"]
    arr = arr.nil? ? [] : arr.map { |label| label["name"] }

    if json_data["listContent"]
      arr << "TODO"
    else
      arr << "googleKeep未分類"
    end
    arr
  end
  def get_content(json_data)
    return validate(Nokogiri::HTML(json_data["textContentHtml"]).css('p > span').text) if json_data["textContentHtml"]
    if json_data["listContent"]
      return json_data["listContent"].map { |item|
      if item['text'].match(/^# /)
        "\n#{item['text']}"
      else
        "- #{item['isChecked'] ? '[x]' : '[ ]'} #{item['text']}"
      end

      }.join("\n")
    end
    raise "No content found in #{title}"
  end

  def file_name
    FileName.new(title, created_at, tags).to_s
  end

  def notify_progress(filepath)
    puts "Markdown file '#{filepath}' has been created."
  end

  def validate(text)
    text.gsub(/(<br>)+/, "\n").gsub('#[a-z|A-Z]+ ', ' ')
  end

  class FileName
    def initialize(title, created_at, tags)
      @title = title
      @created_at = created_at
      @tags = tags
    end

    def to_s
      title = title || @tags.take(2).join('_')
      "#{DateTime.parse(created_at).strftime('%Y%m%d')}_#{title}.md"
    end
  end
end

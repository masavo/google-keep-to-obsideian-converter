class MarkdownFormatter
  def initialize(data, folder_name, attachment_processor)
    @data = data
    @image_files = attachment_processor.image_files.map { |image_file| image_file.sub('output_folder', '.') }
    @audio_files = attachment_processor.audio_files.map { |audio_file| audio_file.sub('output_folder', '.') }
  end

  def to_markdown
    markdown_text = <<~MARKDOWN
      ---
      created_at: #{@data.created_at}
      updated_at: #{@data.updated_at}
      ---
      #{labels_to_markdown}

      #{content_to_markdown}
    MARKDOWN
    markdown_text.gsub(/\n\n+/, "\n\n")
  end

  private

  def content_to_markdown
    content = @data.content.nil? ? '' : @data.content
    markdown_content = content + list_content_to_markdown
    markdown_content += image_files_to_markdown unless @image_files.empty?
    markdown_content += audio_files_to_markdown unless @audio_files.empty?

    markdown_content.lines.map(&:strip).join("\n")
  end

  def list_content_to_markdown
    return '' if @data.list_content.nil? || @data.list_content.empty?

    @data.list_content.map do |item|
      if item["isChecked"]
        "- [x] #{item["text"]}"
      else
        "- [ ] #{item["text"]}"
      end
    end.join("\n")
  end

  def image_files_to_markdown
    content = ""
    @image_files.each do |file_path|
      content += "\n![[#{file_path}]]"
    end
    content
  end

  def audio_files_to_markdown
    content = ""
    @audio_files.each do |file_path|
      content += "\n![[Recording #{file_path}]]"
    end
    content
  end

  def labels_to_markdown
    @data.labels.map { |label| "##{label}" }.join(' ')
  end
end

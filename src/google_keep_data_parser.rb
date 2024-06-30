require 'json'
require 'date'

class GoogleKeepDataParser
  attr_reader :title, :created_at, :updated_at, :content, :labels, :attachments, :list_content

  def initialize(json)
    @json_data = JSON.parse(json)
    parse
  end

  def title
    safe_title = @raw_title.empty? ? @labels.take(2).join('_') : @raw_title
    safe_title
      .sub(/^- */, '')
      .gsub(/\//,'／')
      .gsub('#', '')
      .strip
  end

  private

  def parse
    @raw_title = @json_data["title"]
    @created_at = Time.at(@json_data["createdTimestampUsec"] / 1_000_000).to_datetime.to_s
    @updated_at = Time.at(@json_data["userEditedTimestampUsec"] / 1_000_000).to_datetime.to_s
    @attachments = @json_data["attachments"] || []
    @labels = get_labels
    @content = remove_labels_from_content
    @list_content = @json_data["listContent"]
  end

  def remove_labels_from_content
    content = @json_data["textContent"]
    return nil if content.nil?
    unless default_labels.empty?
      default_labels.each do |label|
        content = content.gsub("##{label}", '')
      end
    end
    content
  end

  def default_labels
    @json_data["labels"] ? @json_data["labels"].map { |label| label["name"] } : []
  end

  def get_labels
    labels = default_labels
    labels += ["TODO"] if list_content&.any?
    labels += ["画像"] if has_image?
    labels += ["録音"] if has_audio?
    labels += ["未分類"] if labels.empty?
    puts labels
    labels
  end

  def has_image?
    puts attachments
    attachments&.any? { |attachment| attachment["mimetype"].start_with?("image/") }
  end

  def has_audio?
    attachments&.any? { |attachment| attachment["mimetype"].start_with?("audio/") }
  end
end

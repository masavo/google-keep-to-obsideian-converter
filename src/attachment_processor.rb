require 'fileutils'

class AttachmentProcessor
  def initialize(attachments, input_folder, output_folder)
    @attachments = attachments || []
    @input_folder = input_folder
    @output_folder = output_folder
    @audio_files = []
    @image_files = []
  end

  def process
    return if @attachments.empty?

    @attachments.each do |attachment|
      if attachment["mimetype"].start_with?("image/")
        save_image(attachment)
      elsif attachment["mimetype"].start_with?("audio/")
        save_audio(attachment)
      end
    end
  end

  def image_files
    @image_files
  end

  def audio_files
    @audio_files
  end

  private

  def save_image(attachment)
    source_path = File.join(@input_folder, attachment["filePath"])
    image_path = File.join(@output_folder, "attachments", attachment["filePath"])
    FileUtils.mkdir_p(File.dirname(image_path))
    FileUtils.cp(source_path, image_path)
    @image_files << image_path
  end

  def save_audio(attachment)
    source_path = File.join(@input_folder, attachment["filePath"])
    audio_path = File.join(@output_folder, "attachments", attachment["filePath"])
    FileUtils.mkdir_p(File.dirname(audio_path))
    FileUtils.cp(source_path, audio_path)
    @audio_files << audio_path
  end
end

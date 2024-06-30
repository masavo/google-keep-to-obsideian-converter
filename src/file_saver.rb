require 'fileutils'
require 'time'

class FileSaver
  def initialize(filepath, content, data)
    @filepath = filepath
    @content = content
    @data = data
  end

  def save
    File.write(@filepath, @content)
    set_file_times
  end

  private

  def set_file_times
    created_time = Time.parse(@data.created_at)
    updated_time = @data.updated_at ? Time.parse(@data.updated_at) : created_time
    File.utime(created_time, updated_time, @filepath)
  end
end

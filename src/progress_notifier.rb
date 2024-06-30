class ProgressNotifier
  def initialize(message)
    @message = message
  end

  def notify
    puts @message
  end
end

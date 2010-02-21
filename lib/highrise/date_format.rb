require 'time'

class Time
  def highrise_format
    getgm.strftime("%Y%m%d%H%M%S")
  end
end
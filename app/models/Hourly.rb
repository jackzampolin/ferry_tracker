require_relative 'WUHTTP.rb'

class Hourly
  def initialize(weather_station_id)
    @raw_json = WUHTTP.send_request(weather_station_id).body['hourly_forecast']
  end
  def pull_attr(attribute,secondary='none')
    output = []
    @raw_json.each do |hash|
      if hash[attribute][secondary]
        output << hash[attribute][secondary]
      else
        output << hash[attribute]
      end
    end
    output
  end
  def feelslike
    pull_attr('feelslike','english')
  end
  def temp
    pull_attr('temp', 'english')
  end
  def dewpoint
    pull_attr('dewpoint','english')
  end
  def wind_speed
    pull_attr('wspd','english')
  end
  def wind_direction
    pull_attr('wdir','degrees')
  end
  def humidity
    pull_attr('humidity')
  end
end

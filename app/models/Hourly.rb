class Hourly
  # Actually calls the API on initialize.  Strips out all the relevant data for each attribute and returns it in a string to be saved as JSON in the DB.
  def initialize(weather_station_id)
    @raw_json = WUHTTP.send_request(weather_station_id).body['hourly_forecast']
  end

  def pull_attr(attribute,secondary='none')
    @raw_json.map do |hash|
      if hash[attribute][secondary]
        hash[attribute][secondary]
      else
        hash[attribute]
      end
    end
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

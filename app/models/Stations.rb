class Stations
  class << self
    def set(lat,lng)
      WUHTTP.location_fix(lat,lng).map do |hash|
        if hash['id'] && hash['neighborhood']
          station = Station.new(
            lat: hash['lat'],
            lng: hash['lon'],
            pws_id: "pws:#{hash['id']}",
            name: hash['neighborhood']
            )
          if station.valid?
            station.save
          end
        end
      end
    end

    def set_forecasts
      Station.all.each do |station|
        hourly = Hourly.new(station.pws_id)
        forecast = Forecast.create(
          station_id: station.id,
          feelslike: hourly.feelslike.to_json,
          temp: hourly.temp.to_json,
          dewpoint: hourly.dewpoint.to_json,
          wind_speed: hourly.wind_speed.to_json,
          wind_direction: hourly.wind_direction.to_json,
          humidity: hourly.humidity.to_json
          )
        station.forecast_id = forecast.id
        station.save
      end
    end

  end

end
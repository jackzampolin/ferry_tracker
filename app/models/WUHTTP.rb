require_relative '../../config/environment.rb'

require 'json'
require 'net/http'
require 'unirest'
require 'pp'

class WUHTTP

  @@counter = 0

  class << self

    def query_string ( query, features='hourly', settings='', format='json' )
      "http://api.wunderground.com/api/#{WUAPI_KEY}/#{features}/#{settings}q/#{query}.#{format}"
    end

    # Can take either a station_id (pws:MD3200 or airport code) or a Url

    def sleep_time(num)
      return nil if num == 0
      p "Waiting for API.  Another #{num} seconds before blast."
      sleep 1
      sleep_time(num-1)
    end

    def send_request(station_id)
      @@counter += 1
      if @@counter % 10 == 0
        sleep_time(60)
        if station_id.length < 17
          Unirest.get query_string(station_id)
        else
          Unirest.get station_id
        end
      else
        if station_id.length < 17
          Unirest.get query_string(station_id)
        else
          Unirest.get station_id
        end
      end
    end

    # need to reset autoip to the lat lng from the browser

    def location_fix(lat,lng)
      output = []
      send_request(query_string("#{lat},#{lng}",'geolookup')).body['location']['nearby_weather_stations'].each do |key,value|
        output << value['station']
      end
      output.flatten
    end

  end
end

# Ask for location from browser?  HTML5 Geolocation API.
# AJAX calls for secondary query requests?
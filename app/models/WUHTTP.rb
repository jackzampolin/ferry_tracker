class WUHTTP

  @@counter = 0

  class << self

    # Can take either a station_id (pws:MD3200 or airport code) or a Url

    def query_string ( query, features='hourly', settings='', format='json' )
      "http://api.wunderground.com/api/#{ENV['WUAPI_KEY']}/#{features}/#{settings}q/#{query}.#{format}"
    end

    # Prevents program from hitting API more than 10x per min.

    def sleep_time(num)
      return nil if num == 0
      p "Waiting for API.  Another #{num} seconds before blast."
      sleep 1
      sleep_time(num-1)
    end

    # Given a PWS_ID from WU sends a request for the data about that station.

    def send_request(station_id)
      @@counter += 1
      if @@counter % 10 == 0
        sleep_time(60)
      end
      Unirest.get query_string(station_id)
    end

  end
end
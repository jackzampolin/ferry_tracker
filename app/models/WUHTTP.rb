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
      p "#{num} #{num} #{num} #{num} #{num} #{num} #{num} #{num} #{num} #{num} #{num} #{num}"
      sleep 1
      sleep_time(num-1)
    end

    # Given a PWS_ID from WU sends a request for the data about that station.

    def send_request(station_id)
      @@counter += 1
      if @@counter % 10 == 0
        sleep_time(60)
      end
      if station_id.length > 20
        Unirest.get station_id
      else
        Unirest.get query_string(station_id)
      end
    end

    # def make_array(tl, tr, bl, br, n)
    # # input are lat-long 2-arrays. THANK YOU PETER.
    #   output = []
    #   n.times do |i|
    #     del_lat1 = tr[0]-tl[0]
    #     del_lat2 = br[0]-bl[0]
    #     del_long1 = bl[1]-tl[1]
    #     del_long2 = br[1]-tr[1]
    #     # insert min magic here
    #     del_lat1 > del_lat2 ? del_lat_min = del_lat2 : del_lat_min = del_lat1
    #     del_long1 > del_long2 ? del_long_min = del_long2 : del_long_min = del_long1
    #     chunk = Array.new(2)
    #     chunk[0] = tl[0]+del_lat_min * rand()
    #     chunk[1] = tl[1]+del_long_min * rand()
    #     output << chunk
    #   end
    #   output
    # end

  end
end
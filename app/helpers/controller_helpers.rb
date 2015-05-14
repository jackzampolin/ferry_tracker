helpers do

  module Help
    def self.parse_array(json_raw)
      # Parses raw json from the database and makes it into and array of integers.
      array = JSON.parse(json_raw).map(&:to_i)
    end

    def self.point_around(lat,lng,radius,radians)
      #returns a lat-lng pair contained in an array that is a point around a circle at radians position with radius = radius with center defined by the lat,lng put in.
      [lat + (radius * Math.cos(radians)),lng + (radius * Math.sin(radians))]
    end

    def self.poly_points(lat,lng)
      # give an array in this form [[lat,lng],[lat,lng],[lat,lng],[lat,lng],[lat,lng],[lat,lng],[lat,lng]] that defines a hexagon around a central lat,lng pair.
      pi = Math::PI
      [(pi),(4*pi/3),(5*pi/3),(0),(pi/3),(2*pi/3)].map do |value|
        point_around(lat,lng,0.009,value)
      end
    end

    def self.color_hash(atr)
      # creates a number of key value pairs with the form { value => hex_color }
      temps = atr.flatten.uniq.sort
      Hash[temps.zip(Hex.colors(temps.length))]
    end
  end

  class ControllerHelpers
    include Help
    def self.map_data(forecast_type)
      # Formats database for sending to JS.  Takes a symbol arguement for the type of forecast desired.
      temps = []
      output = Station.all.each.map do |station|
        attribute = Help.parse_array(station.forecast[forecast_type])
        temps << attribute
        [station.pws_id,Help.poly_points(station.lat,station.lng),attribute]
      end
      output << Help.color_hash(temps)
      output.to_json
    end
  end

end
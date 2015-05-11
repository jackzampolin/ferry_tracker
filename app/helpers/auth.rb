require 'cpalette'

def parse_array(json_raw)
  array = JSON.parse(json_raw).map(&:to_i)
end

def point_around(lat,lng,radius,radians)
  #returns a lat lng array
  [lat + (radius * Math.cos(radians)),lng + (radius * Math.sin(radians))]
end

def poly_points(lat,lng)
  pi = Math::PI
  radian_values = [(pi),(4*pi/3),(5*pi/3),(0),(pi/3),(2*pi/3)]
  radian_values.map do |value|
    point_around(lat,lng,0.008,value)
  end
end

def color_hash(atr)
  temps = atr.flatten.uniq.sort
  Hash[temps.zip(Cpalette.palette(temps.length, {:hex => true}))]
end

def format_db_poly
  collection = []
  temps = []
  Station.all.each do |station|
    collection << [station.name,poly_points(station.lat,station.lng)]
  end
  Forecast.all.each_with_index do |forecast, index|
    collection[index] << parse_array(forecast.feelslike) && temps << parse_array(forecast.feelslike)
  end
  collection << color_hash(temps)
  collection
end
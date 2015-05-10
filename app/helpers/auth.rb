def parse_array(json_raw)
  array = JSON.parse(json_raw)
  array.map(&:to_i)
end
def format_db
  collection = []
  Station.all.each do |station|
    collection << [station.name,station.lat,station.lng]
  end
  Forecast.all.each_with_index do |forecast, index|
    collection[index] << parse_array(forecast.feelslike)
  end
  collection.to_json
end
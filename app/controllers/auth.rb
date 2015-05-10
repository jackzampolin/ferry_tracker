require 'pry'
get '/' do
  erb :welcome
end

post '/stations' do
  if request.xhr?
    collection = []
    Station.all.each do |station|
      collection << [station.name,station.lat,station.lng]
    end
    Forecast.all.each_with_index do |forecast, index|
      collection[index] << parse_array(forecast.feelslike)
    end
    content_type :json
    response = collection.to_json
    response
  else
    status 404
    redirect '/'
  end
end

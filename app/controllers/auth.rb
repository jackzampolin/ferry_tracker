get '/' do
  erb :welcome
end

post '/data' do
  if request.xhr?
    @lat = params['lat']
    @lng = params['lng']
    stations = Stations.new(@lat,@lng)
    stations.to_json
  else
    status 404
    redirect '/'
  end
end
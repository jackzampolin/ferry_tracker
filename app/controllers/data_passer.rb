get '/' do
  erb :map
end

post '/stations' do
  if request.xhr?
    ControllerHelpers.map_data(:feelslike)
  else
    status 404
    redirect '/'
  end
end



get '/' do
  erb :map
end

post '/stations' do
  if request.xhr?
    ControllerHelpers.map_data(params['layer'].to_sym)
  else
    status 404
    redirect '/'
  end
end


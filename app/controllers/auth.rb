require 'pry'
get '/' do
  erb :welcome
end

post '/stations' do
  if request.xhr?
    format_db_poly.to_json
    # binding.pry
  else
    status 404
    redirect '/'
  end
end



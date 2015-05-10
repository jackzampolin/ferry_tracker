require 'pry'
get '/' do
  erb :welcome
end

post '/stations' do
  if request.xhr?
    format_db_poly
    # binding.pry
  else
    status 404
    redirect '/'
  end
end



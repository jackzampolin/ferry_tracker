require 'json'
require 'net/http'

####################################
# WUAPI Accessor for Heat Map App
####################################
# WUAPI.create_query(query,features='hourly',settings='',format='json')
# Formats a query string to hit Weather Underground's servers
####################################
# WUAPI.send_request(query_string)
# Sends the HTTP request and parses the resulting JSON string.
####################################
# WUAPI.location_fix
# Calling send request and pulling the wrappers off the station hashes.
# Fixes location at the ip of the computer calling the request.
####################################
# NOTE: loc_fix is the result of calling WUAPI.location_fix
# WUAPI.station_data_array(loc_fix)
# Strips off the layers around the individual station data hashes
####################################
# WUAPI.station_names(loc_fix)
# Pulls the station names from the data array
####################################
# WUAPI.query_strings(loc_fix)
# Mapping over names and creating query strings.
# All of these return valid WUnderground things.
####################################
# WUAPI.blast(loc_fix)
# Sending the blast of HTTP requests for station specific weather data
####################################
# WUAPI.blast_to_file(file, loc_fix)
# Blast and then write results to a file
####################################

class WUAPI

  class << self

    def create_query( query, features='hourly', settings='', format='json' )
      "http://api.wunderground.com/api/615f6d0dc69178d0/#{features}/#{settings}q/#{query}.#{format}"
    end

    def send_request(query_string)
      JSON.parse(Net::HTTP.get(URI(query_string)), symbolize_names: true)
    end

    def location_fix
      send_request(create_query('autoip','geolookup'))[:location][:nearby_weather_stations]
    end

    def station_data_array(loc_fix)
      output = Array.new
      loc_fix.each { |key, value| output << value[:station] }.flatten
      output.flatten
    end

    def station_names(loc_fix)
      station_data_array(loc_fix).map { |hash| hash[:icao] ? hash[:icao] : hash[:id] }
    end

    def query_strings(loc_fix)
      station_names.map { |query_id| query_id.length > 5 ? create_query("pws:#{query_id}") : create_query(query_id) }
    end

    def blast(loc_fix)
      query_strings.map { |html| send_request(html) }
    end

    def blast_to_file(file, loc_fix)
      File.open(file,"w") { |f| f.write(blast.to_json) }
    end

  end

end

# require_relaive 'wuapi.rb'
# loc_fix = WUAPI.location_fix
# Do Some AJAX and load page
# WUAPI.blast(loc_fix)
# WUAPI.blast_to_file("../../db/20150507230930.json", loc_fix)

# AJAX calls for secondary query requests?
# Ask for location from browser?  HTML5 Geolocation API.
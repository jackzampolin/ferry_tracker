require_relative 'WUHTTP.rb'
require_relative 'Hourly.rb'

class Station
  attr_accessor :lat, :lng, :name, :hourly
  def initialize(hash)
    @lat = hash['lat']
    @lng = hash['lon']
    @name = hash['icao'] ? hash['icao'] : "pws:#{hash['id']}"
    @hourly = nil
  end
  def to_json
    [@name,@lat.to_f,@lng.to_f]
  end
end

class Stations
  attr_reader :data
  def initialize(lat,lng)
    @data = WUHTTP.location_fix(lat,lng).map do |hash|
      Station.new(hash)
    end
  end
  def to_json
    @data.map { |station| station.to_json }.to_json
  end
  def set_hourly
    @data.each do |station|
      station.hourly = Hourly.new(station.name)
    end
  end
end
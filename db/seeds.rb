require 'json'
require 'net/http'
require 'pp'
require 'time'
require 'date'

raw_http_req = Net::HTTP.get(URI('http://www.fleetmon.com/api/p/personal-v1/myfleet/?username=zampolinj&api_key=b855f3e694d8c49dfb642af2b804fcec3a300c57&format=json'))

raw_json = JSON.parse(raw_http_req, symbolize_names: true)[:objects]
raw_json.each do |hash|
  raw_state = hash[:vessel]
  Ferrystate.create(
    course: raw_state[:course],
    destination: raw_state[:destination],
    etatime: raw_state[:etatime],
    heading: raw_state[:heading],
    lastport_departure: raw_state[:lastport][:departure], # nested structue
    lastport_arrival: raw_state[:lastport][:arrival], # nested structure
    lastport_name: raw_state[:lastport][:name], # nested structure
    latitude: raw_state[:latitude],
    longitude: raw_state[:longitude],
    mmsinumber: raw_state[:mmsinumber],
    name: raw_state[:name],
    navigationstatus: raw_state[:navigationstatus],
    positionreceived: raw_state[:positionreceived],
    speed: raw_state[:speed])
end

all_events = Ferrystate.all
ferry_names = Array.new(all_events.length) { |index| all_events[index].name }.uniq!

array_by_ship = Array.new

ferry_names.each do |name|
	array_by_ship << Ferrystate.where(name: name)
end

data_hash_array = Hash.new

array_by_ship.each do |ship_array|
	data_hash_array["#{ship_array[0].name}"] = {
		latitude: Array.new,
		longitude: Array.new,
		created_at: Array.new,
		positionreceived: Array.new,
	}
	ship_data_hash = data_hash_array["#{ship_array[0].name}"]
	ship_array.each do |event|
		cr_at = event.created_at.to_datetime
		pos_rec = event.positionreceived.to_datetime
		def utc_offset(num)
			if num - 7 > 0
				num
			else
				num + 24 - 7
			end
		end
		ship_data_hash[:latitude] << event.latitude
		ship_data_hash[:longitude] << event.longitude
		ship_data_hash[:created_at] << "#{cr_at.yday}: #{utc_offset(cr_at.hour)}:#{cr_at.min}:#{cr_at.sec}"
		ship_data_hash[:positionreceived] << "#{pos_rec.yday}: #{utc_offset(pos_rec.hour)}:#{pos_rec.min}:#{pos_rec.sec}"
	end
end

data_hash_array.each do |key,value|
	pp key
	value.each do |key_i, value_i|
		pp key_i
		pp value_i[-1]
		pp ""
	end
	pp ""
end
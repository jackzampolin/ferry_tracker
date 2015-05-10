SF_POINTS.each do |latlng_arr|
  Stations.set(latlng_arr[0],latlng_arr[1])
end

Stations.set_forecasts
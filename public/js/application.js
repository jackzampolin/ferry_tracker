var map;

var counter = 0;

function initialize() {
  // Setting the map options.
  var mapOptions = {
    center: { lat: 37.767662, lng: -122.444759 },
    zoom: 13,
    zoomControl: false,
    mapTypeControl: false,
  };
  // Creating the map.
  map = new google.maps.Map(document.getElementById('map-canvas'),
      mapOptions);
  // Grabbing the data and feeding it into my drawing funcitons.
  $.ajax({
    url: "/stations",
    type: "post",
    dataType: "json",
    success: function(response){
      setColorKey(response[response.length - 1]);
      stationsDataLoop(response);
    }
  });
}

// Increment the counter after each setTimeout loop.
function count(){
  counter++;
  if(counter == 36){
    counter = 0;
  };
};

// Set the color key on the right center of the map.
function setColorKey(colorHash){
  // Initializing tempGradient to store created divs
  var tempGradient = document.createElement('div');
  tempGradient.id = 'tempGradient';
  for (var key in colorHash) {
    if (colorHash.hasOwnProperty(key)) {
      // creating each individual div with associated temp and color.
      var colorDiv = document.createElement('div');
      colorDiv.style.backgroundColor = colorHash[key];
      colorDiv.innerHTML = key;
      colorDiv.class = 'colorDiv';
      tempGradient.insertBefore(colorDiv, tempGradient.childNodes[0]);
    };
  };
  // https://developers.google.com/maps/documentation/javascript/reference?csw=1#ControlPosition
  map.controls[google.maps.ControlPosition.RIGHT_CENTER].push(tempGradient)
};

function setTimer(counter){
  // Sets the timer at the top of the screen to show which time is being displayed.
  time = document.getElementById('time')
  if (!!time === false) {
    time = document.createElement('div');
    time.id = 'time';
    time.innerHTML = counter;
    map.controls[google.maps.ControlPosition.TOP_CENTER].push(time)
  } else {
    time.innerHTML = counter
  };
};

function drawHexes(stations){
  // Pulling the color object off the end of the whole JSON object.
  var colors = stations[stations.length - 1];
  for ( i = 0 ; i < stations.length - 1 ; i++ ){
    var station = stations[i];
    var one_polygon = [];
    // Setting the polygon points in the internal for loop.
    for ( j = 0 ; j < station[1].length ; j++ ){
      // Station[1][j] is where the latlng array for each point is. [0] = lat, [1] = lng.
      one_polygon.push(new google.maps.LatLng(station[1][j][0],station[1][j][1]));
    };
    // Drawing the polygon and setting the properties.
    var new_station = new google.maps.Polygon({
      paths: one_polygon,
      strokeColor: colors[station[2][counter]],
      strokeOpacity:0.0,
      strokeWeight:0.0,
      fillColor: colors[station[2][counter]],
      fillOpacity:0.03
    });
    // Setting the station with its polygon on the map.
    new_station.setMap(map);
  };
  setTimer(counter);
  count();
};

var stationsDataLoop = function(stations) {
  // redrawing the stations every 100ms with new colors and temps.
  setTimeout(function(){
    drawHexes(stations);
  stationsDataLoop(stations);
}, 100)};

google.maps.event.addDomListener(window, 'load', initialize);

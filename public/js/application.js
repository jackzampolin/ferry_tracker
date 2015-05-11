var map;
var counter = 0;
function initialize() {
  var mapOptions = {
    center: { lat: 37.767662, lng: -122.444759 },
    zoom: 13
  };
  map = new google.maps.Map(document.getElementById('map-canvas'),
      mapOptions);
  $.ajax({
    url: "/stations",
    type: "post",
    dataType: "json",
    error: function (response){
      response = JSON.parse(response);
      debugger
      alert('Woops! Something went wrong!');
    },
    success: function(response){
      stationsDataLoop(response);
    }
  });
}

function drawHexes(stations){
  var output = [];
  var colors = stations[stations.length - 1];
  for ( i = 0 ; i < stations.length - 1 ; i++ ) {
    var station = stations[i];
    var one_hex = [];
    for ( j = 0 ; j < station[1].length ; j++ ){
      var station_pts = station[1];
      new_latlng = new google.maps.LatLng(station_pts[j][0],station_pts[j][1]);
      one_hex.push(new_latlng);
    };
    new_shape = new google.maps.Polygon({
      paths: one_hex,
      strokeColor: colors[station[2][counter]],
      strokeOpacity:0.0,
      strokeWeight:0.1,
      fillColor: colors[station[2][counter]],
      fillOpacity:0.05
    })
    output.push(new_shape);
  };
  for ( i = 0 ; i < output.length ; i++ ) {
    output[i].setMap(map);
  }; counter++;
  if (counter === 35) {
    counter = 0;
  };
};

var stationsDataLoop = function(stations) {
  setTimeout(function(){
    console.log(counter);
    drawHexes(stations);
  stationsDataLoop(stations);
}, 10)};

google.maps.event.addDomListener(window, 'load', initialize);

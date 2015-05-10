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
      drawHexes(response);
    }
  });
}

function drawHexes(stations){
  output = [];
  for ( i = 0 ; i < stations.length ; i++ ) {
    var station = stations[i];
    var one_hex = [];
    for ( j = 0 ; j < station[1].length ; j++ ){
      var station_pts = station[1];
      new_latlng = new google.maps.LatLng(station_pts[j][0],station_pts[j][1]);
      one_hex.push(new_latlng);
    };
    new_shape = new google.maps.Polygon({
      paths: one_hex,
      strokeColor:"#0000FF",
      strokeOpacity:0.0,
      strokeWeight:0.1,
      fillColor:"#0000FF",
      fillOpacity:0.1
    })
    output.push(new_shape);
  };
  for ( i = 0 ; i < output.length ; i++ ) {
    output[i].setMap(map);
  };
};

google.maps.event.addDomListener(window, 'load', initialize);

// function stationsData(stations,index){
//   output = [];
//   for ( i = 0 ; i < stations.length ; i++) {
//     var station = stations[i];
//     output.push({
//       location: new google.maps.LatLng(station[1], station[2]),
//       weight: station[3][index],
//       radius: 200,
//       opacity: .5
//     });
//   };
//   return output;
// };

// var stationsDataLoop = function(stations) {
//   setTimeout(function(){
//     counter++;
//     console.log(counter);
//     stat = stationsData(stations,counter);
//     var heatmap = new google.maps.visualization.HeatmapLayer({
//       data: stat
//     });
//     heatmap.setMap(map);
//     if (counter === 35) {
//       counter = 0;
//     };
//   stationsDataLoop(stations);
// }, 20)};
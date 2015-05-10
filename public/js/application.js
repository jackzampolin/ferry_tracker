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
        alert('Woops! Something went wrong!');
    },
    success: function(response){
      stationsDataLoop(response)
    }
  });
}

function stationsData(stations,index){
  output = [];
  for ( i = 0 ; i < stations.length ; i++) {
    var station = stations[i];
    output.push({
      location: new google.maps.LatLng(station[1], station[2]),
      weight: station[3][index],
      radius: 200,
      opacity: .5
    });
    output
  };
  return output;
};

var stationsDataLoop = function(stations) {
  setTimeout(function(){
    counter++;
    console.log(counter);
    stat = stationsData(stations,counter);
    var heatmap = new google.maps.visualization.HeatmapLayer({
      data: stat
    });
    heatmap.setMap(map);
    if (counter === 35) {
      counter = 0;
    };
  stationsDataLoop(stations);
}, 20)};

google.maps.event.addDomListener(window, 'load', initialize);


// function setMarkers(map, stations) {
//   var image = {
//     url: 'https://cdn4.iconfinder.com/data/icons/8-bit/160/bit-38-16.png',
//     size: new google.maps.Size(16,8),
//     origin: new google.maps.Point(0,0),
//     anchor: new google.maps.Point(16,8)
//   };
//   var shape = {
//       coords: [1,1,1,8,8,16,16,1],
//       type: 'poly'
//   };
//   for (var i = 0; i < stations.length; i++) {
//     var station = stations[i];
//     var myLatLng = new google.maps.LatLng(station[1], station[2]);
//     var marker = new google.maps.Marker({
//         position: myLatLng,
//         map: map,
//         icon: image,
//         shape: shape,
//         title: station[0],
//         zIndex: i
//     });
//   }
// }
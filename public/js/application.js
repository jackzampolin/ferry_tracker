var map;
function initialize() {
  var mapOptions = {
    zoom: 13
  };
  map = new google.maps.Map(document.getElementById('map-canvas'),
      mapOptions);
  // Try HTML5 geolocation
  if(navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
      var pos = new google.maps.LatLng(position.coords.latitude,
                                       position.coords.longitude);
      var infowindow = new google.maps.InfoWindow({
        map: map,
        position: pos,
        content: 'Location found using HTML5.'
      });
      var lat = position.coords.latitude;
      var lng = position.coords.longitude;
      $.ajax({
        url: "/data",
        type: "post",
        dataType: "json",
        data: {lat: lat, lng: lng},
        error: function(request){
          alert("Uh Oh Something Went Wrong...")
        },
        success: function(response){
          var stations = response
          setMarkers(map, stations);
        }
      });
      map.setCenter(pos);
    }, function() {
      handleNoGeolocation(true);
    });
  } else {
    // Browser doesn't support Geolocation
    handleNoGeolocation(false);
  }

}

function setMarkers(map, locations) {
  var image = {
    url: '/app/views/point.png',
    size: new google.maps.Size(8,8),
    origin: new google.maps.Point(0,0),
    anchor: new google.maps.Point(4,4)
  };
  var shape = {
      coords: [1, 1, 1, 8, 8, 8, 8 , 1],
      type: 'poly'
  };
  for (var i = 0; i < locations.length; i++) {
    var station = locations[i];
    var myLatLng = new google.maps.LatLng(station[1], station[2]);
    var marker = new google.maps.Marker({
        position: myLatLng,
        map: map,
        icon: image,
        shape: shape,
        title: station[0],
        zIndex: i
    });
  }
}

function handleNoGeolocation(errorFlag) {
  if (errorFlag) {
    var content = 'Error: The Geolocation service failed.';
  } else {
    var content = 'Error: Your browser doesn\'t support geolocation.';
  }

  var options = {
    map: map,
    position: new google.maps.LatLng(60, 105),
    content: content
  };

  var infowindow = new google.maps.InfoWindow(options);
  map.setCenter(options.position);
}

google.maps.event.addDomListener(window, 'load', initialize);

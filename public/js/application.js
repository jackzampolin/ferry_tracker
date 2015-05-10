var map;
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
    error: function (xhr, textStatus, errorThrown) {
        var test = $.parseJSON(xhr.responseText);
        alert(test);
    },
    success: function(response){
      stations = response;
      debugger
      setMarkers(map, stations);
    }
  });
}



function setMarkers(map, stations) {
  var image = {
    url: 'https://cdn4.iconfinder.com/data/icons/8-bit/160/bit-38-16.png',
    size: new google.maps.Size(16,8),
    origin: new google.maps.Point(0,0),
    anchor: new google.maps.Point(16,8)
  };
  var shape = {
      coords: [1,1,1,8,8,16,16,1],
      type: 'poly'
  };
  for (var i = 0; i < stations.length; i++) {
    var station = stations[i];
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

google.maps.event.addDomListener(window, 'load', initialize);

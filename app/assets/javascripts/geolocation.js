function Map(mapId){
  this.mapId = mapId;
}

Map.prototype.init = function(latitude, longitude){
  var options = {
    center: {lat: latitude, lng: longitude},
    zoom: 15,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };

  this.map = new google.maps.Map(this.mapId, options);
}


$(document).ready(function(){
  if($('#map-canvas').length){
    var latitude = $('#map-canvas').data('latitude');
    var longitude = $('#map-canvas').data('longitude');
    window.myMap = new Map($('#map-canvas')[0]);
    window.myMap.init(latitude, longitude);
  }

  updateRangeValue($('input[type=range]'));
  $('input[type=range]').on('input change',function(){
    var input = $(this);
    updateRangeValue(input);
  });

  function updateRangeValue(input){
    var value = input.val();
    input.next('.rangevalue').html(value + ' kilometers');
  }

  $("#garden-location").on("click", function(event) {
      event.preventDefault();
      garden = $(this).data;
      getLocation();
    });

  $("#search-button").on("click", function(event) {
      event.preventDefault();
      getLocation();
    });

  function geolocationSuccess(position, isLocationDisabled) {
    if($.cookie('latitude') == undefined && $.cookie('longitude') == undefined ) {
    
      var latitude  = position.coords.latitude;
      var longitude = position.coords.longitude;

      $.cookie('latitude', latitude);
      $.cookie('longitude', longitude);

    } else{
      var latitude = $.cookie('latitude');
      var longitude = $.cookie('longitude');
    }

    var noloc = "false";
    var search = getSearchVars();
    var request_object = {
      longitude: longitude,
      latitude: latitude,
      search: search.searchvar,
      proximity: search.proximity
    };
    runAjaxRequest(request_object);
  }

  function geolocationError() {
    // alert("Please enable location for proximity search to work!");
    var noloc = "true";
    var search = getSearchVars();
    var request_object = {
        search: search.searchvar,
        noloc: noloc
      };

    runAjaxRequest(request_object);
  }

  function runAjaxRequest(request) {
    var urlVar = chooseModelToSearch();
    $.ajax({
        url: urlVar,
        method: 'GET',
        data: request,
        dataType: 'script'
      });
  }

  function getSearchVars() {
    var searchObject = {
      searchvar: $('#search-field').val(),
      proximity: $('#proximity').val(),
      searchFor: $('#search-button').val(),
      login: $("#login").val()
    };
    return searchObject;
  };

  function chooseModelToSearch() {
    if($('#search-button').val() == 'product-search'){
      var url = '/products';
    }else if($('#search-button').val() == 'garden-search'){
      var url = '/gardens';
    };
    return url;
  }

  function getLocation() {
    if ("geolocation" in navigator) {
      navigator.geolocation.getCurrentPosition(geolocationSuccess, geolocationError);
    } else {
      alert("Browser does not support geocoding");
    }
  }

});


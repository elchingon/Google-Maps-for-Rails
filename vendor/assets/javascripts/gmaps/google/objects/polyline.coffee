class @Gmaps.Google.Objects.Polyline extends Gmaps.Base

  @include Gmaps.Google.Objects.Common

  constructor: (@serviceObject)->
  
  # TODO Refactor into extendable methods
  panTo: ->
    offsetx = 0
    offsety = -100
    scale = Math.pow(2, @getServiceObject().getMap().getZoom())
    latlng = @primitives().latLngFromPosition(@getServiceObject().getPath().getArray()[0])
    coordinateCenter = @getServiceObject().getMap().getProjection().fromLatLngToPoint(latlng)
    pixelOffset = new google.maps.Point((offsetx/scale) || 0,(offsety/scale) ||0)
    coordinateNewCenter = new google.maps.Point(coordinateCenter.x - pixelOffset.x,coordinateCenter.y + pixelOffset.y)
    newCenter = @getServiceObject().getMap().getProjection().fromPointToLatLng(coordinateNewCenter)
    @getServiceObject().getMap().panTo newCenter

  getPosition: ->
    @primitives().latLngFromPosition(@getServiceObject().getPath().getArray()[0])

  updateBounds: (bounds)->
    bounds.extend ll for ll in @serviceObject.getPath().getArray()

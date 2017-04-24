class @Gmaps.Google.Objects.Polyline extends Gmaps.Base

  @include Gmaps.Google.Objects.Common

  constructor: (@serviceObject)->
  
  panTo: (newCenter) ->
    @getServiceObject().getMap().panTo newCenter

  getPosition: ->
    @primitives().latLngFromPosition(@getServiceObject().getPath().getArray()[0])

  updateBounds: (bounds)->
    bounds.extend ll for ll in @serviceObject.getPath().getArray()

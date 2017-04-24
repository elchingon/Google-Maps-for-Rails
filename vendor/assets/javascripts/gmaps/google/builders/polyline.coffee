class @Gmaps.Google.Builders.Polyline extends Gmaps.Objects.BaseBuilder

  @CURRENT_INFOWINDOW: undefined
  @CURRENT_POLYLINE: undefined
# args:
  #   [
  #     { lat, lng}
  #   ]
  # provider options:
  #   https://developers.google.com/maps/documentation/javascript/reference?hl=fr#PolylineOptions
  constructor: (@args, @provider_options = {}, @internal_options = {})->
    @before_init()
    @create_polyline()
    @create_infowindow_on_click()
    @after_init()

  build: ->
    @polyline = new(@model_class())(@serviceObject)

  create_polyline: ->
    @serviceObject = new(@primitives().polyline)(@polyline_options())

  create_infowindow: ->
    return null unless _.isString @args[0].infowindow
    new(@primitives().infowindow)({content: @args[0].infowindow })

  create_infowindow_on_click: ->
    @addListener 'click', @infowindow_binding

  infowindow_binding: =>
    @constructor.CURRENT_POLYLINE.setOptions({ strokeWeight: 3, strokeOpacity: 1.0 }) if @_should_close_infowindow()
    @constructor.CURRENT_INFOWINDOW.close() if @_should_close_infowindow()
    @polyline.panTo(@newCenter()) unless @internal_options.disableAutoPanTo
    @infowindow = @create_infowindow()
    @getServiceObject().setOptions({ strokeWeight: 8, strokeOpacity: 0.7 })
    return unless @infowindow?

    @infowindow.open( @getServiceObject().getMap(), @polyline)
    @polyline.infowindow ?= @infowindow
    @constructor.CURRENT_INFOWINDOW = @infowindow
    @constructor.CURRENT_POLYLINE = @getServiceObject()

  newCenter: =>
    offsetx = 0
    offsety = -100
    scale = Math.pow(2, @getServiceObject().getMap().getZoom())
    latlng = @primitives().latLngFromPosition(@getServiceObject().getPath().getArray()[0])
    coordinateCenter = @getServiceObject().getMap().getProjection().fromLatLngToPoint(latlng)
    pixelOffset = new(@primitives().point)((offsetx/scale) || 0, (offsety/scale) ||0)
    coordinateNewCenter = new(@primitives().point)(coordinateCenter.x - pixelOffset.x,coordinateCenter.y + pixelOffset.y)
    newCenter = @getServiceObject().getMap().getProjection().fromPointToLatLng(coordinateNewCenter)
    newCenter

  baseStrokeColor: ->
    if _.isString @args[0].baseStrokeColor
      @args[0].baseStrokeColor
    else if _.isString @args[0].strokeColor 
      @args[0].strokeColor
    else
      @polyline_options().baseStrokeColor

  polyline_options: ->
    base_options =
      path:  @_build_path()
      baseStrokeColor: "#000000"
    _.defaults base_options, @provider_options

   _should_close_infowindow: ->
    # console.log(@internal_options)
    # @internal_options.singleInfowindow and @constructor.CURRENT_INFOWINDOW?
    @constructor.CURRENT_INFOWINDOW?

  _build_path: ->
    _.map @args, (arg)=>
      new(@primitives().latLng)(arg.lat, arg.lng)

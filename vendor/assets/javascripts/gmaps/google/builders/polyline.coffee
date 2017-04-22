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
    @constructor.CURRENT_POLYLINE.setOptions({ strokeColor:"#000000" }) if @_should_close_infowindow()
    @constructor.CURRENT_INFOWINDOW.close() if @_should_close_infowindow()
    @polyline.panTo() unless @internal_options.disableAutoPanTo
    @infowindow = @create_infowindow()
    @getServiceObject().setOptions({ strokeColor:"#ff00ee" })
    return unless @infowindow?

    @infowindow.open( @getServiceObject().getMap(), @polyline)
    @polyline.infowindow ?= @infowindow
    @constructor.CURRENT_INFOWINDOW = @infowindow
    @constructor.CURRENT_POLYLINE = @getServiceObject()

  polyline_options: ->
    base_options =
      path:  @_build_path()
    _.defaults base_options, @provider_options

   _should_close_infowindow: ->
    # console.log(@internal_options)
    # @internal_options.singleInfowindow and @constructor.CURRENT_INFOWINDOW?
    @constructor.CURRENT_INFOWINDOW?

  _build_path: ->
    _.map @args, (arg)=>
      new(@primitives().latLng)(arg.lat, arg.lng)

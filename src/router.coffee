Backbone = require 'backbone'
CompositeView = require './composite'
_ = require 'underscore'

cache = {}

if Backbone.$
  _.uniqueId = (prefix='default')->
    if cache[prefix]
      id = ++cache[prefix] + ""
    else
      id = cache[prefix] = 1
    prefix + id

class Router extends Backbone.Router

  fetcher: (dataSources)->
    callback = =>
      @trigger 'doneFetch'
    if _(dataSources).isArray()
      cb = _.after(dataSources.length, callback)
      for item in dataSources
        item.fetch success: cb
      @lastFetched = dataSources
    else
      dataSources.fetch success: callback
      @lastFetched = [dataSources]

  getAppView: ->
    new CompositeView
      uniqueName: @uniqueName

  constructor: ->
    @firstBoot = yes
    @appView = new @getAppView()
    if options?.routes then @routes = options.routes
    @_bindRoutes()
    @initialize.apply this, arguments
    # All navigation that is relative should be passed through the navigate
    # method, to be processed by the router. If the link has a `data-bypass`
    # attribute, bypass the delegation completely.
    Backbone.$?(document).on "click", "a[href]:not([data-bypass])", (evt) ->
      # Get the absolute anchor href.
      href =
        prop: Backbone.$(this).prop("href")
        attr: Backbone.$(this).attr("href")

      # Get the absolute root.
      root = location.protocol + "//" + location.host + '/'
      # Ensure the root is part of the anchor href, meaning it's relative.
      if href.prop.slice(0, root.length) is root
        # Stop the default event to ensure the link will not cause a page
        # refresh.
        evt.preventDefault()
        # `Backbone.history.navigate` is sufficient for all Routers and will
        # trigger the correct events. The Router's internal `navigate` method
        # calls this anyways.  The fragment is sliced from the root.
        Backbone.history.navigate href.attr, true
    this

  # Remove old view add new view to the application view
  swap: (view)->
    oldView = @view if @view
    @appView.removeView oldView if oldView
    @view = view
    @appView.addView view
    if Backbone.$ then @appView.render() unless @firstBoot
    @firstBoot = no

module.exports = Router

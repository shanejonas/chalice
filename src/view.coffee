_ = require 'underscore'
Backbone = require 'backbone'

# Cached regex to split keys for `delegate`.
delegateEventSplitter = /^(\S+)\s*(.*)$/

class View extends Backbone.View

  className: 'view'

  # Call original backbone constructor
  constructor: (options={})->
    @template = options.template if options.template
    @cid = options.cid if options.cid
    super

  # Empty function left for your own template
  template: ->

  # If we have jQuery then try to get the element out of the dom.
  # Calling super here wont do anything if `@el` is defined but when it
  # isn't it will create the element using jQuery.
  # This method does nothing on the server
  _ensureElement: ->
    if Backbone.$?
      @el = @getElFromDom()
      super

  # Only insert into the dom if we have jQuery and we aren't on first boot.
  # if we are on the server return a wrapped string and dont call afterRender.
  #
  #       view = new View
  #       # client side
  #       view.render()
  #       => view
  #       # server side
  #       view.render()
  #       => '<div class=\'view\' data-cid=\'view1\' ></div>'
  #
  render: ->
    unless @$el?.html @toHTML(no)
      return @toHTML(yes)
    @afterRender()
    this

  # Called immediately after creating the markup string and inserting it.
  # passing `true` will try to look for the `el` in the dom and assign events.
  # This is useful for list views where you call `toHTML` on children and 
  # want to bind their events after.
  afterRender: (ensureElement)->
    if ensureElement
      @_ensureElement()
      @delegateEvents()

  # dont use delegateEvents on the server
  delegateEvents: ->
    if Backbone.$ then super

  # dont use undelegateEvents on the server
  undelegateEvents: ->
    if Backbone.$ then super

  # find the current `el` in the dom by using `cid`
  getElFromDom: ->
    Backbone.$("[data-cid='#{@cid}']")[0]

  # ovverride this and return an object to get passed to the template
  getTemplateData: ->

  # return a string of the template + data
  # if passed `yes` it will include the wrapping element for this view.
  toHTML: (wrap=yes)->
    template = @template? @getTemplateData()
    template or= ''
    if not wrap then return template
    @wrap template

  # wrap template in wrapping element for this view.
  wrap: (string)->
    result = ''
    result += "<#{@tagName} class='#{@className}' data-cid='#{@cid}' >"
    result += string
    result += "</#{@tagName}>"
    result

  # remove element, don't remove the dom element unless we have jQuery and
  # stop listening for events.
  remove: ->
    @trigger 'remove', this
    @$el?.remove()
    @stopListening()
    @undelegateEvents()
    this

  delegateEvents: (events) ->
    if not @$el? then return
    return  unless events or (events = _.result(this, "events"))
    @undelegateEvents()
    for key of events
      method = events[key]
      method = this[events[key]]  unless _.isFunction(method)
      if not method then method = => @trigger events[key]
      match = key.match(delegateEventSplitter)
      eventName = match[1]
      selector = match[2]
      method = _.bind(method, this)
      eventName += ".delegateEvents" + @cid
      if selector is ""
        @$el.on eventName, method
      else
        @$el.on eventName, selector, method

module.exports = View

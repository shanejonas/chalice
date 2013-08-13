_ = require 'underscore'
Controller = require './controller.coffee'
View = require './view.coffee'

class ViewController extends Controller

  events: {}

  constructor: (options={}) ->
    @view = options?.primaryView or @getPrimaryView()
    super options
    @bindEvents @view

  bindEvents: (view) ->
    @stopListening view
    for event, method of @events
      if @[method]? then @listenTo view, event, @[method]
      else throw new Error "method #{method} doesnt exist"

  unbindEvents: (view) ->
    @stopListening view

  push: (controller) ->
    @bindEvents controller.view
    super
    @view.swap controller.view

  pop: ->
    controller = _(@childControllers).last()
    @unbindEvents controller.view
    super
    last = _(@childControllers).last()
    @view.swap last.view

  getPrimaryView: ->
    new View

  destructor: ->
    @stopListening()
    @view?.remove()
    @view = null
    super

module.exports = ViewController

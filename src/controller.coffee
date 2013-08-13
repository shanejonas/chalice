Backbone = require 'backbone'
_ = require 'underscore'

class Controller
  _.extend @prototype, Backbone.Events

  constructor: ->
    @childControllers = []

  onControllerDestroy: (controller) ->
    @childControllers = _(@childControllers).without controller
    @stopListening controller

  push: (controller) ->
    @childControllers.push controller
    @listenTo controller, 'destroyed', @onControllerDestroy

  pop: ->
    controller = null
    # keep reference to controller here
    controller = @childControllers.pop()
    # call destructor for cleanup
    controller?.destructor()
    controller = null

  destructor: ->
    for controller in @childControllers
      @stopListening controller
      controller.destructor()
    @childControllers = []
    @trigger 'destroyed', this

module.exports = Controller

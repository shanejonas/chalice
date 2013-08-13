Backbone = require 'backbone'
#TODO: better spies with sinon

describe 'Server', ->

  beforeEach ->
    @app =
      configure: ->
      getCalled: 0
      get: ->
        @getCalled++

  it 'can be required', ->
    require('../../src/server')(@app)

  it 'can add a route to express instead of backbone.history', ->
    class MyRouter extends Backbone.Router
      routes:
        '': 'index'

      index: ->

    require('../../src/server')(@app)
    new MyRouter
    @app.getCalled.should.equal 1

  it 'can add multiple routes to express instead of backbone.history', ->
    class MyRouter extends Backbone.Router
      routes:
        '': 'index'
        'other': 'other'

      index: ->

      other: ->

    require('../../src/server')(@app)
    new MyRouter
    @app.getCalled.should.equal 2

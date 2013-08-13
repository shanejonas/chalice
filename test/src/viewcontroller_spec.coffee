ViewController = require '../../src/viewcontroller'
Controller = require '../../src/controller'
View = require '../../src/view'
assert = require 'assert'
sinon = require 'sinon'

describe 'ViewController', ->

  it 'noops', ->
    ViewController.should.be.a.function

  it 'extends a controller', ->
    (new ViewController).should.be.an.instanceof Controller

  it 'takes a primaryView as an option', ->
    view = new View
    controller = new ViewController
      primaryView: view
    (controller.view).should.eql view

  describe 'primary view', ->

    it 'has a primary view', ->
      (new ViewController).view.should.exist

    it 'has a primary view that is a chalice view', ->
      (new ViewController).view.should.be.an.instanceof View

  describe 'on primary view destroy', ->

    it 'removes view when destructor is called', ->
      controller = new ViewController
      controller.destructor()
      assert.equal(controller.view, null)

  describe 'events', ->

    it 'can catch bubbled up events from the primary view', ->

      class MyController extends ViewController

        getPrimaryView: ->
          new View

        events:
          'myEvent': 'myFunction'

        myFunction: ->

      spy = sinon.spy MyController::, 'myFunction'
      myController = new MyController
      myController.view.trigger 'myEvent'
      spy.callCount.should.equal 1
      MyController::myFunction.restore()

    it 'throws an error when the method doesnt exist', ->

      class MyController extends ViewController

        getPrimaryView: ->
          new View

        events:
          'myEvent': 'myFunction'

      (-> new MyController).should.throw 'method myFunction doesnt exist'


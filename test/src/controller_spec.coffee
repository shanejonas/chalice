Controller = require '../../src/controller'
View = require '../../src/view'

describe 'Controller', ->

  it 'noops', ->
    Controller.should.be.a.function

  describe 'push', ->

    it 'has a push method', ->
      (new Controller).push.should.exist

    it 'keeps an array of childControllers', ->
      controller = new Controller
      mainController = new Controller
      mainController.push controller
      mainController.childControllers.should.eql [controller]

  describe 'pop', ->

    it 'has a pop method', ->
      (new Controller).pop.should.exist

    it 'removes from an array of childControllers', ->
      controller = new Controller
      mainController = new Controller
      mainController.push controller
      mainController.childControllers.should.eql [controller]
      mainController.pop()
      mainController.childControllers.should.eql []

  describe 'destructor', ->

    it 'removes all childControllers', ->
      controller = new Controller
      controller2 = new Controller
      mainController = new Controller
      mainController.push controller
      mainController.push controller2
      mainController.childControllers.should.eql [controller, controller2]
      mainController.destructor()
      mainController.childControllers.should.eql []

    it 'removes a controller when destroy is trigger on a child controller', ->
      controller = new Controller
      controller2 = new Controller
      mainController = new Controller
      mainController.push controller
      mainController.push controller2
      mainController.childControllers.should.eql [controller, controller2]
      controller.destructor()
      mainController.childControllers.should.eql [controller2]
      controller2.destructor()
      mainController.childControllers.should.eql []

Backbone = require 'backbone'

describe 'CompositeView', ->

  CompositeView = require '../../src/composite'

  it 'should exist', ->
    CompositeView.should.be.a.function

  it 'can be instantiated', ->
    view = new CompositeView
    view.should.exist

  it 'has a className', ->
    view = new CompositeView
    view.className.should.equal 'composite-view'

  it 'keeps an array of views', ->
    view = new CompositeView
    view.should.have.property('views')

  it 'can add views', ->
    view = new CompositeView
    newView = new CompositeView
    view.addView newView
    view.views[0].should.equal newView

  it 'can remove views', ->
    view = new CompositeView
    newView = new CompositeView
    view.addView newView
    view.removeView newView
    view.views.should.be.empty

  describe 'rendering', ->

    it 'toHTML returns rendered views as a string', ->
      view = new CompositeView
      newView = new CompositeView
      view.addView newView
      results = view.toHTML()
      expected = newView.toHTML(yes)
      results.should.equal expected

  # use cheerio to fake jquery client side for testing
  describe 'client side', ->
    cheerio = require('cheerio')
    cheerio::off = ->
    cheerio::on = ->

    afterEach: ->
      Backbone.$ = null

    it 'can render views', ->
      Backbone.$ = cheerio.load('<body></body>')
      view = new CompositeView
      newView = new CompositeView
      view.addView newView
      results = view.render().$el.html()
      expected = '<div class="composite-view" data-cid="' + newView.cid + '"></div>'
      results.should.equal expected


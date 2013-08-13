Backbone = require 'backbone'

describe 'View', ->
  View = require '../../src/view'

  it 'should exist', ->
    View.should.be.a.function

  it 'can be instantiated', ->
    view = new View
    view.should.exist

  it 'takes template as an option', ->
    template = -> "STRING"
    view = new View
      template: template
    template.should.equal view.template

  it 'has an empty function as a default template', ->
    view = new View
    view.template.should.be.a.function

  it 'can be removed', ->
    view = new View
    view.remove().should.be.OK

  it 'can get initialized with events', ->
    view = new View
      events:
        'click': 'render'
    view.should.be.OK

  # use cheerio to fake jquery client side for testing
  describe 'client side', ->
    cheerio = require('cheerio')

    afterEach: ->
      Backbone.$ = null

    it 'has an element', ->
      Backbone.$ = cheerio.load('<body></body>')
      view = new View
      view.should.have.property 'el'
      view.should.have.property '$el'

    it 'loads an element already in the dom', ->
      html = "<div data-cid='view7'><section></section></div>"
      expected = "<section></section>"
      Backbone.$ = cheerio.load("<body>#{html}</body>")
      view = new View cid: 'view7'
      view.$el.length.should.equal 1

    it 'can render with data', ->
      template = require './fixtures/test.hbs'

      #override getTemplateData instead of making a model..
      oldGetTemplateData = View::getTemplateData
      View::getTemplateData = -> {data: "TEST"}
      cheerio::on = ->
      cheerio::off = ->
      Backbone.$ = cheerio.load("<body></body>")
      view = new View
        template: template
        uniqueName: 'view7'
      result = view.render().$el.html()
      # handlebars adds a newline at the end...
      result.should.equal "<div>TEST</div>\n"

      # set it back
      View::getTemplateData = oldGetTemplateData

  describe 'rendering', ->

    it 'returns this from render', ->
      view = new View
      result = view.render()
      view.should.equal result

    it 'returns a wrapped string from toHTML with force', ->
      template = -> "STRING"
      view = new View
        template: template
      result = view.toHTML(yes)
      expected = "<div class='view' data-cid='#{view.cid}' >STRING</div>"
      result.should.equal expected

    it 'returns html as a string from toHTML', ->
      template = -> "STRING"
      view = new View
        template: template
      result = view.toHTML(no)
      result.should.equal "STRING"

    it 'returns html with data filled in from toHTML', ->
      template = require './fixtures/test.hbs'

      #override getTemplateData instead of making a model..
      oldGetTemplateData = View::getTemplateData
      View::getTemplateData = -> {data: "TEST"}

      view = new View
        template: template
      result = view.toHTML(no)
      # handlebars adds a newline at the end...
      result.should.equal "<div>TEST</div>\n"

      # set it back
      View::getTemplateData = oldGetTemplateData

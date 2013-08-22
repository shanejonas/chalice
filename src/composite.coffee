View = require './view'
_ = require 'underscore'

class CompositeView extends View

  className: 'composite-view'

  # set up views
  constructor: ->
    super
    @views = []
    if @collection
      @stopListening @collection
      @listenTo @collection, 'add', @addOne
      @listenTo @collection, 'reset', @addAll

  # remove a view
  removeView: (view)->
    @stopListening view
    view.remove()
    @views = _(@views).without view

  # call remove on each child view
  remove: ->
    super
    view.remove() for view in @views
    @views = []
    this

  # Ensure element when calling toHTML on children (except first boot).
  render: ->
    unless @$el?.html @toHTML no
      return @toHTML yes
    @afterRender yes
    this

  # Call afterRender on children
  afterRender: ->
    _.invoke @views, 'afterRender', yes
    super

  # add a view to manage
  addView: (view)->
    @views.push view

  # Call toHTML on all children and concat the templates into one string
  # Wrap if necessary
  toHTML: (wrap=no)->
    views = @views
    template = (view.toHTML(yes) for view in views).join ''
    if not wrap then return template
    @wrap template

  # Add a single model to the list by creating a view for it, and
  # appending its element the list element. You can not have it append by
  # passing false to the insert param.
  addOne: (model, insert=yes) ->
    view = new @childViewType
      model: model
    @listenTo view, 'remove', @removeView
    @addView view
    if insert then @$el?.append view.render().el

  # Add all items in the collection at once.
  addAll: ->
    # teardown views
    if @views?.length > 0 then @removeView view for view in @views
    @views = []
    # add new views back one by one, but dont repaint
    @addOne model, no for model in @collection.models
    @render()

module.exports = CompositeView

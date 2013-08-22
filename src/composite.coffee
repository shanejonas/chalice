View = require './view'
_ = require 'underscore'

class CompositeView extends View

  className: 'composite-view'

  # set up views
  constructor: ->
    super
    @views = []

  # add a view to manage
  addView: (view)->
    @views.push view

  # remove a view
  removeView: (view)->
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
    returns = super
    if @$el? then view.afterRender(yes) for view in @views
    returns

  # Call toHTML on all children and concat the templates into one string
  # Wrap if necessary
  toHTML: (wrap=no)->
    views = @views
    template = (view.toHTML(yes) for view in views).join ''
    if not wrap then return template
    @wrap template

module.exports = CompositeView

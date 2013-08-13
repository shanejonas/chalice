handlebars = require 'handlebars'
Backbone = require 'backbone'
connect = require 'connect'
_ = require 'underscore'
fs = require 'fs'

# add support for handlebar templates on the server
handlebarify = (module, filename) ->
  template = handlebars.compile fs.readFileSync filename, 'utf8'
  module.exports = (context) ->
    template context
require.extensions['.hbs'] = handlebarify
require.extensions['.html'] = handlebarify

cache = {}

_.uniqueId = (prefix='default')->
  if cache[prefix]
    id = ++cache[prefix] + ""
  else
    id = cache[prefix] = 1
  prefix + id

# you must pass in the  express `app` and an `index` template that takes `data` and `markup`.
module.exports = (app, index)->

  # add some configuration options for express
  app.configure ->
    app.use connect.compress()
    app.use connect.bodyParser()
    app.use app.router
    app.disable 'x-powered-by'

  # Override the `route` function to bind to express instead.
  Backbone.Router::route = (route, name) ->

    # Manually add the route to the beginning supersceding the rest of the
    # already added routes.

    startingCount = cache['view']

    app.get '/' + route, (req, res) =>

      # reset _.uniqueId's counter
      cache['view'] = startingCount

      @once 'doneFetch', =>
        # When the app gets all the data it requested through the fetcher,
        # send the markup and app data back in the response.
        data = if not @lastFetched
          ''
        else
          JSON.stringify (modelOrcollection.toJSON() for modelOrcollection in @lastFetched)
        view = @appView.render()
        template = index
          data: data
          markup: view
        res.end template
      @[name] _.values(req.params)


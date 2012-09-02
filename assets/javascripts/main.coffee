$ ->

  #
  # Event
  #

  class Event extends Backbone.Model

    defaults:
      title: null
      content: null

  #
  # EventCollection
  #

  class EventCollection extends Backbone.Collection

    model: Event

    url: "#{window.http_api_url}/events"

    comparator: (event) ->
      -event.get('id')

  #
  # EventView
  #

  class EventView extends Backbone.View

    tagName: 'li'

    template: _.template($('#event-template').html())

    initialize: ->
      _.bindAll @

      @model.bind 'change', @render
      @model.bind 'remove', @unrender

    render: =>
      @$el.html(@template(@model.toJSON()))
      @

    unrender: =>
      $(@el).remove()

    remove: -> @model.destroy()

  #
  # MainView
  #

  class MainView extends Backbone.View

    el: $ 'body'

    initialize: (collection) ->
      _.bindAll @

      @collection = collection
      @collection.bind 'add', @prependEvent
      @collection.bind 'reset', @render

      @render()

    render: ->
      $(@el).html '<ul id="events"></ul>'
      $('ul#events').append(@renderEvent(event)) for event in @collection.models

    renderEvent: (event) ->
      event_view = new EventView model: event
      event_view.render().el

    prependEvent: (event) ->
      $('ul').prepend(@renderEvent(event))

  #
  # Main
  #

  toBase64 = (str) ->
    words = CryptoJS.enc.Latin1.parse(str)
    CryptoJS.enc.Base64.stringify(words)

  $.ajaxSetup
    headers:
      Authorization: "Basic #{toBase64(":#{window.http_api_key}")}"

  collection = new EventCollection
  collection.fetch()
  view = new MainView(collection)

  # poll for new events (but use ids to request only new ones)
  setInterval ->
    last_id = if collection.models.length > 0
      collection.models[0].get("id")
    else
      0
    $.ajax
      data:
        since: last_id + 1
      dataType: 'json'
      url: "#{window.http_api_url}/events"
      success: (data) ->
        collection.add(event) for event in data
  , 10000

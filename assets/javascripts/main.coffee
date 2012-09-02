$ ->

  #
  # Event
  #

  class Event extends Backbone.Model

    defaults:
      title: 'Hello'
      content: 'Backbone'

  #
  # EventCollection
  #

  class EventCollection extends Backbone.Collection

    model: Event

    url: "#{window.http_api_url}/events"

    comparator: (event) ->
      event.get('published_at')

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
      @collection.bind 'add', @appendEvent
      @collection.bind 'reset', @render

      @render()

    render: ->
      $(@el).append '<ul></ul>'
      @appendEvent event for event in @collection.models

    addEvent: ->
      @counter++
      event = new Event
      event.set content: "#{event.get 'content'} #{@counter}"
      @collection.add event

    appendEvent: (event) ->
      event_view = new EventView model: event
      $('ul').append event_view.render().el

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
  view = new MainView(collection)
  collection.fetch()

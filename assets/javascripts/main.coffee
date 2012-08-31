$ ->

  class Event extends Backbone.Model

    defaults:
      title: 'Hello'
      content: 'Backbone'

  class List extends Backbone.Collection

    model: Event

  class EventView extends Backbone.View

    tagName: 'li'

    initialize: ->
      _.bindAll @

      @model.bind 'change', @render
      @model.bind 'remove', @unrender

    render: =>
      $(@el).html """
        <span>#{@model.get 'title'} #{@model.get 'content'}!</span>
        <span class="swap">swap</span>
        <span class="delete">delete</span>
      """
      @

    unrender: =>
      $(@el).remove()

    swap: ->
      @model.set
        title: @model.get 'content'
        content: @model.get 'title'


    remove: -> @model.destroy()

    events:
      'click .swap': 'swap'
      'click .delete': 'remove'


  class ListView extends Backbone.View

    el: $ 'body'

    initialize: ->
      _.bindAll @

      @collection = new List
      @collection.bind 'add', @appendEvent

      @counter = 0
      @render()

    render: ->
      $(@el).append '<button>Add Event List</button>'
      $(@el).append '<ul></ul>'

    addEvent: ->
      @counter++
      event = new Event
      event.set content: "#{event.get 'content'} #{@counter}"
      @collection.add event

    appendEvent: (event) ->
      event_view = new EventView model: event
      $('ul').append event_view.render().el

    events: 'click button': 'addEvent'

  Backbone.sync = (method, model, success, error) ->
    success()

  list_view = new ListView

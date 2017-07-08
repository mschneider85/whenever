App.participation = App.cable.subscriptions.create 'ParticipationChannel',
  connected: ->
    # Called when the subscription is ready for use on the server
    console.log 'connected'

  disconnected: ->
    # Called when the subscription has been terminated by the server
    console.log 'disconnected'

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    @render(data)

  render: (data) ->
    query = '[data-participation-id="' + data.id + '"]'

    actions =
      'create': ->
        unless document.querySelectorAll(query).length
          document.getElementById('participations').innerHTML += data.content
      'destroy': ->
        document.querySelector(query).remove()
    actions[data.action]()

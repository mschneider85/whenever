App.clearParticipationForm = ->
  document.querySelectorAll('.dynamic').forEach (field) ->
    if field.getAttribute('type') == 'checkbox'
      field.checked = false
    else
      field.value = ''

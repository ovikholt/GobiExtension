window.addEventListener 'message', (event) ->
  if event.source is window and event.data.type is 'INSTANTIATE_BUBBLES'
    bubbles = new gobi.Bubbles
      container: '#' + event.data.id
      stories: event.data.stories
      autoSegue: true
    (window.gobiBubbleSets = window.gobiBubbleSets or []).push bubbles

window.postMessage type: 'INSTANTIATOR_LOADED'

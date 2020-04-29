log = console.log.bind console
lastGobiContainer = null
defaultStories = [
  { id: 'b2e9a9fb', title: 'Story 1\nSummer' }
  { id: '941afded', title: 'Story 2\nFall' }
  { id: 'f2091ee5', title: 'Story 3\nWinter' }
]

injectStyle = (innerHTML) ->
  styleElement = document.createElement 'style'
  styleElement.type = 'text/css'
  styleElement.innerHTML = innerHTML
  (document.body or document.head or document.documentElement).appendChild styleElement

injectStyle '.gobi-popup-vfB8k { z-index: 9999; opacity: 1 }'

injectJs = ({src, id, text, onload}) ->
  scriptElement = document.createElement 'script'
  scriptElement.type = 'text/javascript'
  if src then scriptElement.src = src
  if text then scriptElement.text = text
  scriptElement.id = id
  scriptElement.onload = onload # never triggered
  (document.body or document.head or document.documentElement).appendChild scriptElement

createInlineGwiAndInstantiator = (onload) ->
  fetch 'https://unpkg.com/@gobistories/gobi-web-integration@>6.0.0/dist/index.js'
  .then (gwiResponse) ->
    fetch chrome.extension.getURL 'dist/coffee-to-js-output/bubble-instantiator.js'
    .then (instantiatorResponse) ->
      injectJs
        id: 'gobi-web-integration-inline-script'
        text: (await gwiResponse.text()) + ';' + (await instantiatorResponse.text())
  window.addEventListener 'message', (event) ->
    if event.source is window and event.data.type is 'INSTANTIATOR_LOADED'
      onload()

inject = (injectTarget, gobiStoryIds) ->
  lastGobiContainer = document.createElement 'div'
  injectTarget.appendChild lastGobiContainer
  lastGobiContainer.id = 'gobi-container-' + Math.random().toString(36).slice(2)
  gobiStories = gobiStoryIds.map (id) -> { id: id }
  window.postMessage
    type: 'INSTANTIATE_BUBBLES'
    id: lastGobiContainer.id
    stories: if gobiStories.length then gobiStories else defaultStories
  , '*'

letUserClickElement = (gobiStoryIds) ->
  documentWideClickListener = (event) ->
    event = event or window.event
    clickedElement = event.target or event.srcElement
    if document.querySelector '#gobi-web-integration-inline-script'
      inject clickedElement, gobiStoryIds
    else
      createInlineGwiAndInstantiator -> inject clickedElement, gobiStoryIds
    event.preventDefault()
    document.removeEventListener 'click', documentWideClickListener
  document.addEventListener 'click', documentWideClickListener, false
moveGobiUpDomHierarchy = ->
  lastGobiContainer?.parentElement?.parentElement?.appendChild lastGobiContainer
moveGobiRightDomHierarchy = ->
  lastGobiContainer?.parentElement?.insertBefore lastGobiContainer, lastGobiContainer?.nextSibling?.nextSibling or lastGobiContainer?.parentElement?.appendChild lastGobiContainer or moveGobiUpDomHierarchy()
moveGobiLeftDomHierarchy = ->
  lastGobiContainer?.parentElement?.insertBefore lastGobiContainer, lastGobiContainer.previousSibling
setupGobiPopupListener = ->
  chromeMessageListener = (message, sender, sendResponse) ->
    switch message.type
      when 'letUserClickElement'
        sendResponse()  # causes popup to close
        letUserClickElement message.gobiStoryIds
      when 'moveGobiUpDomHierarchy'
        moveGobiUpDomHierarchy()
      when 'moveGobiRightDomHierarchy'
        moveGobiRightDomHierarchy()
      when 'moveGobiLeftDomHierarchy'
        moveGobiLeftDomHierarchy()
  chrome.runtime.onMessage.addListener chromeMessageListener
contentScript = ->
  setupGobiPopupListener()
contentScript()


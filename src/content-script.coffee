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

injectJs = (link, onload) ->
  scriptElement = document.createElement 'script'
  scriptElement.type = 'text/javascript'
  scriptElement.src = link
  scriptElement.onload = onload
  (document.body or document.head or document.documentElement).appendChild scriptElement

inject = (injectTarget, gobiStoryIds) ->
  script = document.createElement 'script'
  script.src = 'https://unpkg.com/@gobistories/gobi-web-integration@>6.0.0/dist/index.js'
  script.type = 'text/javascript'
  script.onload = ->
    lastGobiContainer = document.createElement 'div'
    injectTarget.appendChild lastGobiContainer
    lastGobiContainer.id = 'gobi-' + Math.random().toString(36).slice(2)
    gobiStories = gobiStoryIds.map (id) -> { id: id }
    triggerInstantiateBubbles = ->
      window.postMessage
        type: 'INSTANTIATE_BUBBLES'
        id: lastGobiContainer.id
        stories: if gobiStories.length then gobiStories else defaultStories
      , '*'
    injectJs chrome.extension.getURL('dist/coffee-to-js-output/bubble-instantiator.js'), triggerInstantiateBubbles
  (document.body or document.head or document.documentElement).appendChild script
letUserClickElement = (gobiStoryIds) ->
  documentWideClickListener = (event) ->
    event = event or window.event
    clickedElement = event.target or event.srcElement
    inject clickedElement, gobiStoryIds
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


log = console.log.bind console
`const gobi = require('@gobistories/gobi-web-integration')`
lastGobiContainer = null
defaultStories = [
  { id: 'b2e9a9fb' }
  { id: '941afded' }
  { id: 'f2091ee5' }
]
inject = (injectTarget, gobiStoryIds) ->
  body = document.body or document.getElementByTagName('body')[0]
  lastGobiContainer = document.createElement 'div'
  injectTarget.appendChild lastGobiContainer
  # injectTarget.insertBefore injectTarget.parentNode, lastGobiContainer
  gobiStories = gobiStoryIds.map (id) -> { id: id }
  new gobi.Bubbles
    container: lastGobiContainer
    stories: if gobiStories.length then gobiStories else defaultStories
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
  chrome.runtime.onMessage.addListener chromeMessageListener
contentScript = ->
  setupGobiPopupListener()
# See README.md for build instructions
contentScript()

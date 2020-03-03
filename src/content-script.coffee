log = console.log.bind console

`const gobi = require('@gobistories/gobi-web-integration')`

lastGobiContainer = null

inject = (injectTarget) ->
  body = document.body or document.getElementByTagName('body')[0]

  link = document.createElement 'link'
  link.href = 'https://unpkg.com/@gobistories/gobi-web-integration/dist/gobi-web-integration.css'
  link.rel = 'stylesheet'
  body.appendChild link

  lastGobiContainer = document.createElement 'div'
  injectTarget.appendChild lastGobiContainer
  # injectTarget.insertBefore injectTarget.parentNode, lastGobiContainer
  new gobi.MobileLayout
    container: lastGobiContainer
    stories: [
      { id: '5601374f1437c89b6f6a641c97cc9d751982640f' }
      { id: '42b095ee3d96ad3670ef6e4d638cfeadd75671f5' }
      { id: '1012da7b037762812a6b6ef4e9a2c2a286d8b63e' }
    ]

letUserClickElement = ->
  documentWideClickListener = (event) ->
    event = event or window.event
    clickedElement = event.target or event.srcElement
    inject clickedElement
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
        letUserClickElement()
      when 'moveGobiUpDomHierarchy'
        moveGobiUpDomHierarchy()
      when 'moveGobiRightDomHierarchy'
        moveGobiRightDomHierarchy()
  chrome.runtime.onMessage.addListener chromeMessageListener

contentScript = ->
  setupGobiPopupListener()

# See README.md for build instructions
contentScript()

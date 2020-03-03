getTabs = (callback) ->
  chrome.tabs.query {active: true, currentWindow: true}, callback
firstTabId = null
getTabs (tabs) ->
  firstTabId = tabs[0].id
getTextareaContent = ->
  textarea = document.getElementsByTagName('textarea')[0]
  textarea.value
button = document.getElementsByTagName('button')[0]
button.addEventListener 'click', (event) ->
  responseHandler = (response) ->
    window.close()  # close popup
  content = getTextareaContent()
  gobiStoryIds = content.split(/id=|[^0-9a-f]/).filter((n) -> !!n).map((n) -> n.trim())
  chrome.tabs.sendMessage firstTabId, {type: 'letUserClickElement', gobiStoryIds: gobiStoryIds}, responseHandler
upButton = document.getElementById 'up-dom-hierarchy'
upButton.addEventListener 'click', (event) ->
  chrome.tabs.sendMessage firstTabId, {type: 'moveGobiUpDomHierarchy'}, ->
rightButton = document.getElementById 'right-dom-hierarchy'
rightButton.addEventListener 'click', (event) ->
  chrome.tabs.sendMessage firstTabId, {type: 'moveGobiRightDomHierarchy'}, ->

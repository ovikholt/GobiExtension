getTabs = (callback) ->
  chrome.tabs.query {active: true, currentWindow: true}, callback
firstTabId = null
getTabs (tabs) ->
  firstTabId = tabs[0].id
textarea = document.getElementsByTagName('textarea')[0]
getTextareaContent = ->
  textarea.value
button = document.getElementsByTagName('button')[0]
button.addEventListener 'click', (event) ->
  responseHandler = (response) ->
    window.close()
  content = getTextareaContent()
  gobiStoryIds = content.split(/id=|[^0-9a-f]/).filter((n) -> !!n).map((n) -> n.trim())
  chrome.storage?.sync?.set? gobiStoryIds: gobiStoryIds
  chrome.tabs.sendMessage firstTabId, {type: 'letUserClickElement', gobiStoryIds: gobiStoryIds}, responseHandler

upButton = document.getElementById 'up-dom-hierarchy'
upButton.addEventListener 'click', (event) ->
  chrome.tabs.sendMessage firstTabId, {type: 'moveGobiUpDomHierarchy'}
rightButton = document.getElementById 'right-dom-hierarchy'
rightButton.addEventListener 'click', (event) ->
  chrome.tabs.sendMessage firstTabId, {type: 'moveGobiRightDomHierarchy'}
leftButton = document.getElementById 'left-dom-hierarchy'
leftButton.addEventListener 'click', (event) ->
  chrome.tabs.sendMessage firstTabId, {type: 'moveGobiLeftDomHierarchy'}

chrome.storage?.sync?.get? ['gobiStoryIds'], (result) ->
  if not textarea.value and result.gobiStoryIds
    textarea.value = result.gobiStoryIds.join(' ')

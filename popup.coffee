getTabs = (callback) ->
  chrome.tabs.query {active: true, currentWindow: true}, callback
firstTabId = null
getTabs (tabs) ->
  firstTabId = tabs[0].id

button = document.getElementsByTagName('button')[0]
button.addEventListener 'click', (event) ->
  responseHandler = (response) ->
    window.close()  # close popup
  chrome.tabs.sendMessage firstTabId, {type: 'letUserClickElement'}, responseHandler
upButton = document.getElementById 'up'
upButton.addEventListener 'click', (event) ->
  chrome.tabs.sendMessage firstTabId, {type: 'moveGobiUpDomHierarchy'}, ->


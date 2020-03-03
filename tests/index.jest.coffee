assert = (proposition) ->
  if not proposition
    assertion_failed

tests =
  test_nothing: ->
    assert true

do tests[testName] for testName of tests

console.log 'All tests succeeded.'

test 'a test', ->
  console.log 'inside the test'

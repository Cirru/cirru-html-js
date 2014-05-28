
require 'shelljs/make'

target.compile = ->
  exec 'coffee -o js/ -bc coffee/'
  console.log 'done: compile coffee'

issues = [
  'basic'
  'ctrl'
  'large'
]

target.test = ->
  beautify = require('js-beautify').js_beautify
  render = require('./coffee/index').render

  for issue in issues
    cirruCode = cat "cirru/#{issue}.cirru"
    htmlCode = cat "compiled/#{issue}.js"
    result = render cirruCode
    result = beautify result, indent_size: 2
    if result.trim() is htmlCode.trim()
      console.log "done: passed issue...#{issue}"
    else
      console.log "failed: on issue...#{issue}"
      console.log result
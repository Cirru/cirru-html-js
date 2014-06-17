
require 'shelljs/make'

target.compile = ->
  exec 'coffee -o js/ -bc coffee/'
  console.log 'done: compile coffee'

issues = [
  'basic'
  'ctrl'
  'large'
  'class'
  'each'
]

target.test = ->
  beautify = require('js-beautify').js_beautify
  render = require('./coffee/index').render

  for issue in issues
    codePath = "cirru/#{issue}.cirru"
    cirruCode = cat codePath
    htmlCode = cat "compiled/#{issue}.js"
    result = render cirruCode, codePath
    result = beautify result, indent_size: 2
    if result.trim() is htmlCode.trim()
      console.log "done: passed issue...#{issue}"
    else
      console.log ''
      console.log "failed: on issue...#{issue}"
      console.log result
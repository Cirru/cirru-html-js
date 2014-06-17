
require 'shelljs/make'

JSBench = require 'jsbench'
dot = require 'dot-strip'
render = require('../coffee/index').render

samples = [
  'html'
  'condition'
  'each'
  'class'
]

target['test-compile'] = ->
  cirruSamples = []
  dotSamples = []
  for sample in samples
    cirruSamples.push (cat "cirru/#{sample}.cirru")
    dotSamples.push (cat "dot/#{sample}.html")
  (new JSBench)
  .add 'compile Cirru HTML', ->
    for sample in samples
      render sample
  .add 'compile doT', ->
    for sample in samples
      (dot.template sample).toString()
  .run 6000, yes

target.compile = ->
  for sample in samples
    ex = 'module.exports ='
    cirruCode = (cat "cirru/#{sample}.cirru")
    dotCode = cat "dot/#{sample}.html"

    cirruCompiled = ex + (render cirruCode)
    cirruCompiled.to "cirru-compiled/#{sample}.js"
    dotCompiled = ex + (dot.template dotCode).toString()
    dotCompiled.to "doT-compiled/#{sample}.js"

target['test-run'] = ->
  cirruSamples = []
  dotSamples = []
  data =
    list: []
    checked: yes
  for i in [0..100]
    nest = []
    for j in [0..100]
      nest.push name: 'nest', value: 'nothing'
    data.list.push name: 'name', value: 'value', nest: nest

  for sample in samples
    cirruSamples.push (require "./cirru-compiled/#{sample}")
    dotSamples.push (require "./dot-compiled/#{sample}")

  (new JSBench)
  .add 'Run Cirru HTML', ->
    for sample in cirruSamples
      sample data
  .add 'Run doT', ->
    for sample in dotSamples
      sample data
  .run 1000, yes

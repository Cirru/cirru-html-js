
{parse} = require 'cirru-parser'
{explain} = require './explain'

exports.render = (cirruCode, codePath) ->
  explain (parse cirruCode, codePath)
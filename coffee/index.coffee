
{parse} = require 'cirru-parser'
{explain} = require './explain'

exports.render = (cirruCode) ->
  explain (parse cirruCode)
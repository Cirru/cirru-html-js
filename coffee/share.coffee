
module.exports =
  count: 0
  _variables: []
  declareVariables: ->
    if @_variables.length > 0
      js = "var html='', #{@_variables.join(',')};"
    else js = "var html='';"
    @_variables = []
    return js

  newVar: ->
    varName = "_#{@count}"
    @count += 1
    @_variables.push varName
    varName

  _snippets: []
  add: (snippet) ->
    @_snippets.push snippet

  generateCode: ->
    chunksList = []
    currentState = undefined
    chunk = undefined

    for snippet in @_snippets
      type = if snippet.js? then 'js' else 'html'
      if type is currentState
        chunk.code.push snippet[type]
      else
        if chunk?
          chunksList.push chunk
        chunk =
          type: type
          code: [snippet[type]]
      currentState = type

    chunksList.push chunk

    js = chunksList.map (item) ->
      if item.type is 'js'
        return item.code.join('')

      code = item.code.join('')
      return "html+='#{code}';"
    .join('')
    @_snippets = []
    js
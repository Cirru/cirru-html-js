
tags = require './tags'

share = require './share'

exports.explain = (cirruAsts) ->

  html = ''
  _resource = 'resource'

  for cirruExpr in cirruAsts
    (new Expr cirruExpr, _resource).render()
    html += share.generateCode()

  """(function(resource, call){
    #{share.declareVariables()}
    #{html}
    return html;
  })"""

class Expr
  constructor: (@_cirruExpr, @_resource) ->
    @_info = (new Token @_cirruExpr[0])
    @head = @_info.get()
    @_children = @_cirruExpr[1..].map (item) =>
      if Array.isArray item then new Expr item, @_resource
      else new Token item

    mark = @head[0]
    if mark is '@'
      @type = 'expr'
      @render = @renderExpr
    else if mark is '='
      @type = 'html'
      @render = @renderHtml
    else if mark is ':'
      @type = 'attr'
      @render = @renderAttr
    else
      @type = 'tag'
      @render = @renderTag

  renderTag: ->
    markup = @head

    tagName = 'div'
    tagMatch = markup.match /^[\w\d-_]+/
    if tagMatch?
      tagName = tagMatch[0]
    share.add html: "<#{tagName}"

    idMatch = markup.match /#[\w\d-_]+/
    if idMatch?
      idName = idMatch[0][1..]
      share.add html: " id=\"#{idName}\""

    classMatch = markup.match /\.[\w\d-_]+/g
    if classMatch?
      className = classMatch.map((x)->x[1..]).join(' ')
      share.add html: " class=\"#{className}\""

    if tagName in tags.selfClose
      for expr in @_children
        expr.render()
      share.add html: '>'

      return

    # so tahName is not self-closed
    attrFinished = no

    for expr in @_children
      if expr.type is 'attr'
        if attrFinished
          @caution 'already closed', expr
        expr.render()
      else
        if not attrFinished
          share.add html: '>'
          attrFinished = yes
        expr.render()
    if not attrFinished
      share.add html: '>'
    share.add html: "</#{tagName}>"

  renderAttr: ->
    attr = @head[1..]
    value = @_children[0]
    empty = yes
    share.add html: " #{attr}=\""

    for value in @_children
      if empty then empty = no
      else share.add html: ' '

      if value.type is 'token'
        share.add html: value.get()
      else
        value.render()

    share.add html: '"'

  renderExpr: ->
    markup = @head
    if markup is '@'
      variable = @_children[0]

      unless variable instanceof Token
        @caution '@ requires token', variable

      if @inCondition
        share.add js: "#{@_resource}['#{variable.get()}']"
      else
        share.add js: "html+=#{@_resource}['#{variable.get()}'];"

      return

    if markup is '@if'
      condition = @_children[0]
      trueExpr = @_children[1]
      falseExpr = @_children[2]

      unless condition instanceof Expr
        @caution '@if takes expressions in condition', condition

      share.add js: 'if('
      condition.inCondition = yes
      condition.render()
      share.add js: '){'
      trueExpr.render()
      share.add js: '}'
      if falseExpr?
        share.add js: 'else{'
        falseExpr.render()
        share.add js: '}'

      return

    if markup is '@unless'
      condition = @_children[0]
      trueExpr = @_children[1]
      falseExpr = @_children[2]

      unless condition instanceof Expr
        @caution '@unless takes expressions', condition

      share.add js: 'if(!('
      condition.inCondition = yes
      condition.render()
      share.add js: ')){'
      trueExpr.render()
      share.add js: '}'
      if falseExpr?
        share.add js: 'else{'
        falseExpr.render()
        share.add js: '}'

      return

    if markup is '@each'
      firstNode = @_children[0]

      unless firstNode instanceof Token
        @caution "first parameter of @each supposed to be a token", firstNode

      listName = firstNode.get()
      indexVar = share.newVar()
      valueVar = share.newVar()
      resource = "#{@_resource}['#{listName}']"

      share.add js: "#{indexVar} = 0;"
      share.add js: "while(#{indexVar} < #{resource}.length){"
      share.add js: "#{valueVar}=#{resource}[#{indexVar}];"
      for loopExpr in @_children[1..]
        loopExpr.changeResource valueVar
        loopExpr.render()
      share.add js: "#{indexVar} += 1;"
      share.add js: '}'

      return

    if markup is '@call'
      firstNode = @_children[0]

      unless firstNode instanceof Token
        @caution "@call only takes tokens", firstNode

      method = firstNode.get()
      args = @_children[1..]
      .map (item) => "#{@_resource}['#{item.get()}']"
      .join(',')
      if @inCondition
        share.add js: "call['#{method}'](#{args})"
      else
        share.add js: "html+=call['#{method}'](#{args})"

      return

    if markup is '@rich'
      firstNode = @_children[0]

      unless firstNode instanceof Token
        @caution "first parameter of @rich supposed to be a token", firstNode

      name = firstNode.get()
      contentExpr = @_children[1]
      share.add js: "if(#{@_resource}['#{name}'].length>0){"
      contentExpr.render()
      share.add js: '}'

      return

    if markup is '@block'
      for child in @_children
        child.render()
      return

    @caution "\"#{markup}\" is not valid expression", @_info

  renderHtml: ->
    markup = @head
    text = @_children[0].get()
    if markup is '='
      share.add html: tags.escape(text)

      return

    if markup is '=='
      share.add html: text

      return

    @caution 'not recognize', @head

  changeResource: (_resource) ->
    @_resource = _resource

    @_children.forEach (child) =>
      if child instanceof Expr
        child.changeResource _resource

  caution: (message, ast) ->
    if ast instanceof Expr
      info = ast._info._cirruToken
    else
      info = ast._cirruToken
    file = info.file.path or '__unknown__.cirru'
    line = info.file.text.split('\n')[info.y]
    console.log "\n#{file}:#{info.y}: #{line}"
    throw new Error message

class Token
  constructor: (@_cirruToken) ->

  type: 'token'

  render: ->
    share.add html: @get()

  get: ->
    @_cirruToken.text

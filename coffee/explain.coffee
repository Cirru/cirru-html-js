
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
    @head = (new Token @_cirruExpr[0]).get()
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
    if value.type is 'token'
      share.add html: " #{attr}=\"#{value.get()}\""
    else
      share.add html: " #{attr}=\""
      value.render()
      share.add html: '"'

  renderExpr: ->
    markup = @head
    if markup is '@'
      variable = @_children[0]
      if @inCondition
        share.add js: "#{@_resource}['#{variable.get()}']"
      else
        share.add js: "html+=#{@_resource}['#{variable.get()}'];"

      return

    if markup is '@if'
      condition = @_children[0]
      trueExpr = @_children[1]
      falseExpr = @_children[2]
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
      share.add js: 'if(!('
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
      listName = @_children[0].get()
      loopExpr = @_children[1]
      indexVar = share.newVar()
      valueVar = share.newVar()
      resource = "#{@_resource}['#{listName}']"
      loopExpr.changeResource valueVar

      share.add js: "for(#{indexVar} in #{resource}){"
      share.add js: "#{valueVar}=#{resource}[#{indexVar}];"
      loopExpr.render()
      share.add js: '}'

      return

    if markup is '@call'
      method = @_children[0].get()
      args = @_children[1..]
      .map (item) => "#{@_resource}['#{item.get()}']"
      .join(',')
      if @inCondition
        share.add js: "call['#{method}'](#{args})"
      else
        share.add js: "html+=call['#{method}'](#{args})"

      return

    if markup is '@rich'
      name = @_children[0].get()
      contentExpr = @_children[1]
      share.add js: "if(#{@_resource}['#{name}'].length>0){"
      contentExpr.render()
      share.add js: '}'

      return

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

  caution: (message, ast) ->
    console.log ast
    throw new Error message

class Token
  constructor: (@_cirruToken) ->

  type: 'token'

  render: ->
    share.add html: @get()

  get: ->
    @_cirruToken.text

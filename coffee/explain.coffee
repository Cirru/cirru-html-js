
tags = require './tags'

share =
  count: 0
  _variables: []
  toCode: ->
    if @_variables.length > 0
      "var #{@_variables.join(',')};"
    else ''
  newVar: ->
    "_var_#{@count}"

exports.explain = (cirruAsts) ->

  html = ''
  _resource = '_resource'

  for cirruExpr in cirruAsts
    html += (new Expr cirruExpr, _resource).render()

  """function(_resource){
    #{share.toCode()}
    var _html = '';
    #{html}
    return _html;
  }"""

class Expr
  constructor: (@_cirruExpr, @_resource) ->
    @_func = new Token @_cirruExpr[0]
    @_children = @_cirruExpr[1..].map (item) =>
      if Array.isArray item then new Expr item, @_resource
      else new Token item

    mark = @_func.render()[0]
    if mark is '@'
      @_type = 'expr'
      @render = @renderExpr
    else if mark is '='
      @_type = 'html'
      @render = @renderHtml
    else if mark is ':'
      @_type = 'attr'
      @render = @renderAttr
    else
      @_type = 'tag'
      @render = @renderTag

  render: ->
    @_generator.render()

  renderTag: ->
    markup = @_func.render()

    tagName = 'div'
    tagMatch = markup.match /^[\w\d-_]+/
    if tagMatch?
      tagName = tagMatch[0]
    tagCode = "_html+='<#{tagName}';"

    idMatch = markup.match /#[\w\d-_]+/
    if idMatch?
      idName = idMatch[0][1..]
      tagCode += "_html+=' id=\"#{idName}\"'"

    classMatch = markup.match /\.[\w\d-_]+/g
    if classMatch?
      className = classMatch.map((x)->x[1..]).join(' ')
      tagCode += "_html+=' class=\"#{className}\"'"

    if tagName in tags.selfClose
      for expr in @_children
        tagCode += expr.render()
      tagCode += "_html+='>';"
      return tagCode

    # so tahName is not self-closed
    attrFinished = no

    for expr in @_children
      if expr.getType() is 'attr'
        if attrFinished
          @caution 'already closed', expr
        tagCode += expr.render()
      else
        if not attrFinished
          tagCode += "_html+='>';"
          attrFinished = yes
        if expr.getType() is 'token'
          tagCode += "_html+='#{expr.render()}'"
        else
          tagCode += expr.render()
    if not attrFinished
      tagCode += "_html+='>';"
    tagCode += "_html+='</#{tagName}>'"
    return tagCode

  renderAttr: ->
    attr = @_func.render()[1..]
    value = @_children[0].render()
    "_html+=' #{attr}=\"#{value}\"';"

  renderExpr: ->
    markup = @_func.render()
    if markup is '@'
      variable = @_children[0]
      code = "_html+=#{@_resource}['#{variable.render()}'];"
      return code

    if markup is '@if'
      condition = @_children[0]
      trueExpr = @_children[1]
      falseExpr = @_children[2]
      code = "if(#{condition}){_html+='#{trueExpr.render()}';}"
      if falseExpr?
        code += "else{_html+='#{falseExpr.render()}';}"
      return code

    if markup is '@unless'
      condition = @_children[0]
      trueExpr = @_children[1]
      falseExpr = @_children[2]
      code = "if(!(#{condition})){_html+='#{trueExpr.render()}';}"
      if falseExpr?
        code += "else{_html+='#{falseExpr.render()}';}"
      return code

    if markup is '@each'
      declare = @_children[1]
      loopExpr = @_children[2]
      [items, item] = declare.split('->')
      indexVar = share.newVar()
      resource = "#{@_resource}['#{items}']"
      loopExpr.changeResource item
      code = """for(#{indexVar} in #{resource}){
        #{item}=#{resource}['#{indexVar}'];
        #{loopExpr.render()};
      }"""
      return code

  renderHtml: ->
    markup = @_func.render()
    text = @_children[0].render()
    if markup is '='
      text = text
      .replace /\s/g, '&nbsp;'
      .replace /</g, '&lt;'
      .replace />/g, '&gt;'
      code = "_html+='#{text}';"
      return code
    else if markup is '=='
      code = "_html+='#{text}';"
      return code
    else
      @caution 'not recognize', @_func

  getType: ->
    @_type or 'expr'

  changeResource: (_resource) ->
    @_resource = _resource

  caution: (message, ast) ->
    console.log ast
    throw new Error message

class Token
  constructor: (@_cirruToken) ->

  render: ->
    @_cirruToken.text

  getType: ->
    'token'
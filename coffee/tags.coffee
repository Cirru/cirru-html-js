
exports.selfClose = [
  'area'
  'base'
  'br'
  'col'
  'embed'
  'hr'
  'img'
  'input'
  'keygen'
  'link'
  'meta'
  'param'
  'source'
  'track'
  'wbr'
]

exports.escape = (str) ->
  str
  .replace /\s/g, '&nbsp;'
  .replace />/g, '&gt;'
  .replace /</g, '&lt;'
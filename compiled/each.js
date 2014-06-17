(function(resource, call) {
  var html = '',
    _0, _1, _2, _3;
  for (_0 in resource['a']) {
    _1 = resource['a'][_0];
    html += '<div>';
    html += _1['b'];
    for (_2 in _1['c']) {
      _3 = _1['c'][_2];
      html += '<div>';
      html += _3['d'];
      html += '</div>';
    }
    html += '</div>';
  }
  return html;
})
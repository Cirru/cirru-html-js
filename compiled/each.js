(function(resource, call) {
  var html = '',
    _0, _1, _2, _3;
  _0 = 0;
  while (_0 < resource['a'].length) {
    _1 = resource['a'][_0];
    html += '<div>';
    html += _1['b'];
    _2 = 0;
    while (_2 < _1['c'].length) {
      _3 = _1['c'][_2];
      html += '<div>';
      html += _3['d'];
      html += '</div>';
      _2 += 1;
    }
    html += '</div>';
    _0 += 1;
  }
  return html;
})
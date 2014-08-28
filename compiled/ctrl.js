(function(resource, call) {
  var html = '',
    _0, _1;
  if (call['a'](resource['b'])) {
    html += '<div></div>';
  } else {
    html += '<span></span>';
  }
  _0 = 0;
  while (_0 < resource['members'].length) {
    _1 = resource['members'][_0];
    html += '<div>';
    html += _1['name'];
    html += '</div>';
    _0 += 1;
  }
  return html;
})
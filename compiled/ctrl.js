function(_resource, _call) {
  var _var_0, _var_1;
  var _html = '';
  if (_call['a'](_resource['b'])) {
    _html += '<div';
    _html += '>';
    _html += '</div>'
  } else {
    _html += '<div';
    _html += '>';
    _html += '</div>'
  }
  for (_var_0 in _resource['members']) {
    _var_1 = _resource['members']['_var_0'];
    _html += '<div';
    _html += '>';
    _html += _resource['name'];
    _html += '</div>';
  }
  return _html;
}
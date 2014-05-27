function(_resource) {

  var _html = '';
  _html += '<div';
  _html += ' demo="demo"';
  _html += ' a="aa"';
  _html += '>';
  _html += '<div';
  _html += '>';
  _html += 'x&nbsp;x';
  _html += '</div>'
  _html += _resource['a'];
  _html += '</div>'
  _html += '<a';
  _html += ' class="demo"'
  _html += '>';
  _html += '</a>'
  _html += '<div';
  _html += ' id="b"'
  _html += '>';
  _html += '</div>'
  return _html;
}
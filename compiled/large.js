function(_resource, _call) {
  var _var_0, _var_1, _var_2, _var_3, _var_4, _var_5;
  var _html = '';
  _html += '<div';
  _html += ' id="demo-create-box"'
  _html += '>';
  _html += '<div';
  _html += ' id="demo-create"'
  _html += ' data-lang-text="demo-create"';
  _html += '>';
  _html += '</div>';
  _html += '<input';
  _html += ' id="demo-input"'
  _html += ' data-lang-placeholder="demo-input"';
  _html += '>';
  _html += '</div>';
  if (_resource['more'].length > 0) {
    _html += '<div';
    _html += ' id="demo-more-box"'
    _html += '>';
    _html += '<div';
    _html += ' id="demo-more"'
    _html += ' data-lang-text="demo-more"';
    _html += '>';
    _html += '</div>';
    _html += '<div';
    _html += ' id="demo-more-list"'
    _html += '>';
    for (_var_2 in _resource['room']) {
      _var_3 = _resource['room']['_var_2'];
      _html += '<div';
      _html += ' class="demo-more-room"'
      _html += '>';
      _html += '<span';
      _html += ' class="demo-name"'
      _html += '>';
      _html += _resource['topic'];
      _html += '</span>';
      _html += '<span';
      _html += ' class="demo-join"'
      _html += ' data-lang-text="demo-join"';
      _html += ' data-id="';
      _html += _resource['id'];
      '"';
      _html += '>';
      _html += '</span>';
      _html += '</div>';;
    }
    _html += '</div>';
    _html += '</div>';
  }
  _html += '<div';
  _html += ' id="demo-joined-box"'
  _html += '>';
  _html += '<div';
  _html += ' id="demo-joined"'
  _html += ' data-lang-text="demo-joined"';
  _html += '>';
  _html += '</div>';
  if (_resource['joined'].length > 0) {
    _html += '<div';
    _html += ' id="demo-joined-list"'
    _html += '>';
    for (_var_4 in _resource['joined']) {
      _var_5 = _resource['joined']['_var_4'];
      _html += '<div';
      _html += ' class="demo-joined-room"'
      _html += '>';
      _html += '<div';
      _html += ' class="demo-name"'
      _html += '>';
      _html += _resource['topic'];
      _html += '</div>';
      _html += '<span';
      _html += ' class="demo-checked"'
      _html += '>';
      _html += '✔';
      _html += '</span>';
      _html += '</div>';;
    }
    _html += '</div>';
  }
  _html += '</div>';
  return _html;
}
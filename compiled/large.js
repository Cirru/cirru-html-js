(function(resource, call) {
  var html = '',
    _0, _1, _2, _3;
  html += '<div id="demo-create-box"><div id="demo-create" data-lang-text="demo-create"></div><input id="demo-input" data-lang-placeholder="demo-input"></div>';
  if (resource['more'].length > 0) {
    html += '<div id="demo-more-box"><div id="demo-more" data-lang-text="demo-more"></div><div id="demo-more-list">';
    _0 = 0;
    while (_0 < resource['room'].length) {
      _1 = resource['room'][_0];
      html += '<div class="demo-more-room"><span class="demo-name">';
      html += _1['topic'];
      html += '</span><span class="demo-join" data-lang-text="demo-join" data-id="';
      html += _1['id'];
      html += '"></span></div>';
      _0 += 1;
    }
    html += '</div></div>';
  }
  html += '<div id="demo-joined-box"><div id="demo-joined" data-lang-text="demo-joined"></div>';
  if (resource['joined'].length > 0) {
    html += '<div id="demo-joined-list">';
    _2 = 0;
    while (_2 < resource['joined'].length) {
      _3 = resource['joined'][_2];
      html += '<div class="demo-joined-room"><div class="demo-name">';
      html += _3['topic'];
      html += '</div><span class="demo-checked">✔</span></div>';
      _2 += 1;
    }
    html += '</div>';
  }
  html += '</div>';
  return html;
})
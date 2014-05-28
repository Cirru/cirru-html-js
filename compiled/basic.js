(function(resource, call) {
  var html;
  html += '<div demo="demo" a="aa"><div>x&nbsp;x</div>';
  html += resource['a'];
  html += '</div>';
  html += '<a class="demo"></a>';
  html += '<div id="b"></div>';
  return html;
})
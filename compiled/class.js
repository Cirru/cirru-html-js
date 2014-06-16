(function(resource, call) {
  var html = '';
  html += '<div><div class="a"></div><div class="a b c d"></div><div class="a ';
  html += resource['b'];
  html += ' ';
  html += resource['c'];
  html += ' d"></div><div class="a ';
  if (resource['b']) {
    html += '<div>b</div>';
  } else {
    html += '<div>c</div>';
  }
  html += '"></div><div class="a ';
  if (resource['b']) {
    html += 'b';
  } else {
    html += 'c';
  }
  html += '"></div></div>';
  return html;
})
(function(resource, call) {
  var html = '',
    _0, _1;
  if (call['a'](resource['b'])) {
    html += '<div></div>';
  } else {
    html += '<span></span>';
  }
  for (_0 in resource['members']) {
    _1 = resource['members'][_0];
    html += '<div>';
    html += resource['name'];
    html += '</div>';
  }
  return html;
})
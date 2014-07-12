"use strict";

var methods = {}
  , current_url = window.location.href

window.onerror = function(errorMsg, url, lineNumber) {
  log('log', errorMsg)
}

/**
 * Make a log to change the window's href
 * @param {Array} Array of string to print
 */
var log = methods._log = window._log = function(type) {
  var reply = ""
  for (var i = 1; i < arguments.length; i++) {
    var value = arguments[i]
    if (arguments[i] === Object(arguments[i]) && ((typeof arguments) != "string"))
      value = JSON.stringify(value)
    reply += encodeURIComponent(value)
  }
  
  var iframe = document.createElement('iframe');
  iframe.setAttribute('src', "js://" + type + "/" + reply);
     
  document.documentElement.appendChild(iframe);
  iframe.parentNode.removeChild(iframe);
  iframe = null;

  // window.location.href = "js://" + type + "/" + reply
}

/**
 * Format the output to the way we wanted it
 * @param {Object} error
 * @param {String} key
 * @param {Object} response object
 */
methods._f = window._f = function(err, key, res) {
  var response = {}
  response.status = (err && err.status) || 200
  response.message = (err && err.message) || ""
  response.results = res || {}
  log(key, encodeURIComponent(JSON.stringify(response)))
}

if (typeof module !== 'undefined' && module.exports)
  module.exports = methods
if (window)
  window.app = methods

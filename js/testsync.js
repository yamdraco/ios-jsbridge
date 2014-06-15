"use strict";

var _ = require('underscore')
  , sagent = require('superagent')

/**
 * override window's function
 *
 */
var log = window.log = function() {
  var reply = _.reduce(arguments, function(memo, value) { return memo + ' ' + value }, "")
  window.location.href = "js://log/" + reply
}

var methods = {}
var testFun = methods.testFun = function(a) {
  return 'hello hello ' + a
}

methods.testSync = function() {
  return "sync function work"
}

methods.test_async = function(key, req) {
  log(key, ": pre async function", JSON.stringify(req))
  setTimeout(function() {
    log(key, ": post async funtion")
    methods._f(null, key, {'async':'test passed'})
  }, req._timeout || 30000)
}

methods.http_request = function(key, req) {
  log('yahoo request started')
  sagent.get('http://localhost:3000')
    .end(function(err, res) {
      methods._f(null, key, res.text)
    })
}

methods._f = function(err, key, res) {
  var response = {}
  response.status = (err && err.status) || 200
  response.message = (err && err.message) || ""
  response.results = res || {}
  window.location.href = 'js://' + key + '/' + encodeURIComponent(JSON.stringify(response))
}

if (typeof module !== 'undefined' && module.exports)
  module.exports = methods
if (window)
  window.app = methods

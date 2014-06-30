"use strict";

var _ = require('underscore')
  , sagent = require('superagent')
  , basic = require('./base.js')

/**
 * override window's function
 *
 */
var methods = {}
var testFun = methods.testFun = function(a) {
  return 'hello hello ' + a
}

methods.testSync = function() {
  return "sync function work"
}

methods.test_async = function(key, req) {
  basic._log("log", ": pre async function", JSON.stringify(req))
  setTimeout(function() {
    basic._log(key, {'async':'test passed'})
  }, req._timeout || 30000)
}

methods.http_request = function(key, req) {
  basic._log('yahoo request started')
  sagent.get('http://localhost:3000')
    .end(function(err, res) {
      methods._f(key, res.text)
    })
}

methods.from_js = function(key, req) {
  setTimeout(function() {
    basic._log("data", {'test':'test_data'})
  }, 3000)
}

if (typeof module !== 'undefined' && module.exports)
  module.exports = methods
if (window)
  window.app = methods

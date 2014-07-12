ios-jsbridge
============

An iOS bridge for sending messages between Objective C and Javascript via a UIWebview  
The idea is to allow some workflow and model code to be shared across web app, android and ios  

The ios-bridge is in the process of making currently

The idea of the project is inspired by PhoneGap and Linkedin  
To understand more on the research as well as philosophy of this library
visit http://blog.dracoyam.com/building-hybrid-ios-app-using-javascript-bridge

### Installation
The installation of the library is done via cocoapod  
Add the following in the Podfile
```
pod 'ios-jsbridge', '0.1.0'
```

### Usage (IOS)
#### Sync
IOS Side  
```
NSString *value = [JS runJs:@"app.testFun('string')"]
```
Javascript Side  
```
window.app = {}
app.testFun = function(value) {
  ... // your implementation
  return 'hello world';
}
```
  
#### Async
IOS Side
```
[JS runAsyncJs:@"app.test_async" param:@"" success:^(NSArray *result){
  ... // your implement
} fail:^(NSError* err) {
  ... // handle error when the bridge hits timeout
}]
```
Javascript Side
I have implemented a helper for returning data back to IOS, you can copy this to your javascript file
```
/**
 * Make a log to change the window's href
 * @param {Array} Array of string to print
 */
var log = window._log = function(type) {
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
}
```
In the async application that is fired from the IOS side, usually you will have parameters together with a key in the front
```
window.app = {}
app.test_async = function(key, req) {
  async_function(function(res) {  // custom async function call
    window._log(key, { ... // custom return object / string })  
    // the key is a counter stored on the IOS Side
  })
}
```
  
#### Call IOS from js
A JSBridgeNotification is also implemented to catch custom calls from JS side  
IOS Side
```
[[NSNotificationCenter defaultCenter] addObserverForName:@"JSBridgeNotification" object:nil queue:nil usingBlock:^(NSNotification *notification) {
  ... // custom handling here
  ... notification.userInfo contains {host: '', component: ''}
}];
```
Don't forget to remove the observer in dealloc function  
  
JS Side
```
// Same as sync methods, _log is used, but instead of passing in the key which is not available
// a custom text is passed in 
function() {
  window._log('custom', {test: 'test param'})
}
```
  
You can also look at the IOS_JSBridgeTests.m for looking at how to use them


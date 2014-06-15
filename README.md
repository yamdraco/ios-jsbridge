ios-jsbridge
============

An iOS bridge for sending messages between Objective C and Javascript via a UIWebview  
The idea is to allow some workflow and model code to be shared across web app, android and ios  

The idea of the project is inspired by PhoneGap.  

WARNING: The project currently is considered to be incomplete, more code and test cases will be added  
overtime to ensure the bridge is flexible and robust. Any suggestions to my code is welcome.  
  
  

### Setup  
The bridge itself is a singleton, to use the code  
**Sync**  
This would return the value from a sync function in javascript
```
NSString *value = [JS runJs:@"app.testFun('string')"]
```
**Async**  
Async function is not returned immediately, therefore a callback is provided  
IOS side
```
[JS runAsyncJs:@"app.testAsync" param:@"{}" success:^(NSString *result) {
  // success callback
} fail:^(NSError *err) {
  // fail callback which include a 30s timeout incase the bridge fail
}]
```
JS side  
In the case of async, the interface input and output of javascript is less flexible  
**input**
```
function(key, req) {
  // key is the identifier for each request via javascript bridge is an async matter
  // req is the param
}
```
**output**
```key + '___' + JSONstring```

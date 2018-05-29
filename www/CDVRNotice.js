var cordova = require('cordova');
var exec = require('cordova/exec');
var channel = require('cordova/channel');



var CDVRNotice = function() {
    this.eventObj = null;
    this.eventObj = cordova.addWindowEventHandler("cdvrnoticemessage");
    this.eventObj.onHasSubscribersChange = CDVRNotice.onHasSubscribersChange;
};

function handlers (){
    return cdvrnotice.eventObj.numHandlers;
}

CDVRNotice.onHasSubscribersChange = function() {
  if (this.numHandlers === 1 && handlers() === 1) {
      exec(CDVRNotice.success, CDVRNotice.error, "CDVRNotice", "start", []);
  } else if (handlers() === 0) {
      exec(null, null, "CDVRNotice", "stop", []);
  }
};

CDVRNotice.success = function(info){
    cordova.fireWindowEvent("cdvrnoticemessage", info);
};

CDVRNotice.error = function(){
};

CDVRNotice.prototype.getDeviceToken = function(success,error)
{
  exec(success,error, "CDVRNotice", "getDeviceToken", []);
        
};

CDVRNotice.prototype.regNotify = function(){
    exec(null,null, "CDVRNotice", "regNotify", []);
};
               
var cdvrnotice = new CDVRNotice();
module.exports = cdvrnotice;

channel.onCordovaReady.subscribe(function() {
        cdvrnotice.regNotify();
        channel.onCordovaInfoReady.fire();
                           
});


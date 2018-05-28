var app = {
    // Application Constructor
    initialize: function() {
        document.addEventListener('deviceready', this.onDeviceReady.bind(this), false);
        //document.addEventListener("CDVRNoticeMesasge".this.onNoticeMessage.bind(this),false);
        
        

        
        },
    
    // deviceready Event Handler
    //
    // Bind any cordova events here. Common events are:
    // 'pause', 'resume', etc.
    onDeviceReady: function() {
        this.receivedEvent('deviceready');
        
        
        window.addEventListener("cdvrnoticemessage",this.onNoticeMessage,false);
        //document.addEventListener("CDVRNoticeMesasge",this.onNoticeMessage,false);
        
        navigator.CDVRNotice.getDeviceToken(function success(info)
                                            {
                                                console.log(info);
                                            },function error(){
                                            
                                            });
    },

    onNoticeMessage:function(info){
        console.log(info);
    },
    
    // Update DOM on a Received Event
    receivedEvent: function(id) {
        var parentElement = document.getElementById(id);
        var listeningElement = parentElement.querySelector('.listening');
        var receivedElement = parentElement.querySelector('.received');

        listeningElement.setAttribute('style', 'display:none;');
        receivedElement.setAttribute('style', 'display:block;');

        console.log('Received Event: ' + id);
    }
};

function onNoticeMessage(info){
      console.log(info);
};


app.initialize();
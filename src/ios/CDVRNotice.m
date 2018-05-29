//
//  CDVRNotice.m
//  iyanbian
//
//  Created by hongyun on 2017/4/13.
//
//


#import "CDVRNotice.h"
#import "AppDelegate.h"
@implementation CDVRNotice

static CDVRNotice * cdvrNoticeCurrent = nil;


-(void)pluginInitialize{
    
    //为了防止热更新后程序失去效果callback没有效果。

        cdvrNoticeCurrent = self;
        self.callbackId = nil;
        self.notifyTag =@"CDVRNotice";
        self->deviceToken = nil;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification:) name:self.notifyTag object:nil];

}


-(void)dealloc{
    [self stop:nil];
}

//由ios的appDelegate里面的函数发送通知信息
-(void)onNotification:(NSNotification *)notification{
    
    NSDictionary * userInfo = notification.object;
    
    deviceToken = userInfo;
    
    [self notifyCordova:userInfo];
    
}
//它接受ios的通知，然后在通知给页面
-(void)notifyCordova:(NSDictionary *)userInfo{
    if (self.callbackId != nil) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:userInfo];
        [result setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:result callbackId:self.callbackId];
    }
}

-(void)start:(CDVInvokedUrlCommand*)command{
    self.callbackId = command.callbackId;
}

-(void)stop:(CDVInvokedUrlCommand*)command{
    self.callbackId = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:self.notifyTag object:nil];
}

//由AppDelegate调用设置DeviceToken
+(void)setUserInfo:(NSString *)deviceToken{
    if(cdvrNoticeCurrent != nil){
        cdvrNoticeCurrent->deviceToken = deviceToken;
    }
}

-(void)getDeviceToken:(CDVInvokedUrlCommand *)command{
    
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:self->deviceToken];
    [result setKeepCallbackAsBool:false];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

-(void)regNotify:(CDVInvokedUrlCommand *)command{
    [self.commandDelegate runInBackground:^{
        [AppDelegate registerRemoteNotification];
    }];
};
@end



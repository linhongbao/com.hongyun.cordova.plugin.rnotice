//
//  CDVRNotice.h
//  iyanbian
//
//  Created by hongyun on 2017/4/13.
//
//



#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

@interface CDVRNotice : CDVPlugin{
    NSString * callbackId;
    NSString * notifyTag;
    NSString * deviceToken;
    NSString * regcallBackID;
}

@property (strong) NSString * callbackId;
@property (strong) NSString * notifyTag;
@property (strong) NSString * regcallBackID;


-(void)onNotification:(NSNotification *)notification;
-(void)notifyCordova:(NSDictionary *)userInfo;
-(void)start:(CDVInvokedUrlCommand*)command;
-(void)stop:(CDVInvokedUrlCommand*)command;
-(void)getDeviceToken:(CDVInvokedUrlCommand *)command;
+(void)setUserInfo:(NSString *)deviceToken;
-(void)regNotify:(CDVInvokedUrlCommand*)command;

@end

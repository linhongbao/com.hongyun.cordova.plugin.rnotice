/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

//
//  AppDelegate.m
//  iyb
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <AudioToolbox/AudioToolbox.h>
#import "CDVRNotice.h"
@implementation AppDelegate

static AppDelegate *currAppDelete = nil;

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{

    
    self.viewController = [[MainViewController alloc] init];

    BOOL result =[super application:application didFinishLaunchingWithOptions:launchOptions];

    currAppDelete = self;
    
    return result;
}


//为了让CDVRNotice调用
+(void)registerRemoteNotification{
    
    UNUserNotificationCenter * center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"请求成功");
        } else {
            NSLog(@"请求失败");
        }
    }];
    
    //注册远程通知
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    //设置通知的代理
    center.delegate = currAppDelete;
}


//前台运行推送
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    AudioServicesPlaySystemSound(1002);

    NSDictionary *userInfo = notification.request.content.userInfo;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CDVRNotice" object:userInfo];
    
}

//后台，及程序退出
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
{
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    
    NSLog(@"后台");
    NSInteger a = [UIApplication sharedApplication].applicationIconBadgeNumber;
    a--;
    if(a <0){
        a = 0;
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CDVRNotice" object:userInfo];
    
    
    completionHandler();
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings

{
    
    [application registerForRemoteNotifications];
    
}

//接受到了远程通知注册的deviceToken
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{

    
    //NSString * result = [[NSString alloc] initWithData:deviceToken  encoding:NSUTF8StringEncoding];
    //发送给php服务器，保存token
    //NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:result,@"token",nil];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"CDVRNotice" object:userInfo];
    
    NSString * result = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];

    result =[result stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"%@",result);
    
    [CDVRNotice setUserInfo:result];
    
}
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
}



- (void)application:(UIApplication *)applicationdidFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"Registfail%@",error);
}


@end

//
//  AppDelegate.m
//  QQ音乐项目
//
//  Created by a on 31/3/16.
//  Copyright © 2016年 wtt. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     // Override point for customization after application launch.
     return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
     // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   
     [application beginReceivingRemoteControlEvents];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
     // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
     
     [application endReceivingRemoteControlEvents];
}

- (void)applicationWillTerminate:(UIApplication *)application {
     // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

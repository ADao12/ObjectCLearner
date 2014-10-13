//
//  AppDelegate.m
//  TrainningPlan2
//
//  Created by JiaYing.Cheng on 14-10-10.
//  Copyright (c) 2014年 Flamingo-inc. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

//- (void)dealloc
//{
//    [_window release];
//    [_viewController release];
//    [super dealloc];
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    _viewController = [[ViewController alloc]init];
    _navController = [[UINavigationController alloc]initWithRootViewController:_viewController];
    _window.rootViewController = _navController;
    [self.window makeKeyAndVisible];
    
    //启动本地通知
//    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
//    
//    if (localNotif != nil) {
//        
//        NSCalendar *calendar = [NSCalendar currentCalendar]; // gets default calendar
//        
//        NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[NSDate date]]; // gets the year, month, day,hour and minutesfor today's date
//        
//        [components setHour:21];
//        
//        [components setMinute:44];
//        
//        [components setSecond:14];
//        
//        localNotif.fireDate = [calendar dateFromComponents:components];
//        
//        localNotif.timeZone = [NSTimeZone localTimeZone];
//        
//        localNotif.alertBody = @"该报警了！";
//        
//        
//        
//        localNotif.alertAction = @"打开报警";
//        
//        localNotif.hasAction = YES;
//        
//        localNotif.soundName = @"ping.caf";
//        
//        localNotif.applicationIconBadgeNumber = 4;
//        
//        localNotif.repeatInterval = kCFCalendarUnitDay;
//        
//        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
//        
//    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - sso
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self.viewController.wbapi handleOpenURL:url];
}

//Available in iOS 4.2 and later.
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self.viewController.wbapi handleOpenURL:url];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iWeibo" message:notification.alertBody delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    // 图标上的数字减1
    application.applicationIconBadgeNumber -= 1;
}


@end

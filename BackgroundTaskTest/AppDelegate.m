//
//  AppDelegate.m
//  BackgroundTaskTest
//
//  Created by Daniel Tull on 14.03.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "AppDelegate.h"
#import "DCTLoggingViewController.h"

@interface AppDelegate ()
@property (nonatomic) BOOL shouldLoop;
@property (nonatomic) DCTLoggingViewController *loggingViewController;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
	self.loggingViewController = [DCTLoggingViewController new];
	self.window.rootViewController = self.loggingViewController;
	[self.loggingViewController log:@"%@:%@", self, NSStringFromSelector(_cmd)];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	[self loop:0];
	__block UIBackgroundTaskIdentifier task = [application beginBackgroundTaskWithExpirationHandler:^{
		[self.loggingViewController log:@"ExpirationHandler"];
		self.shouldLoop = NO;
		//[application endBackgroundTask:task];
		
		UILocalNotification *notification = [UILocalNotification new];
		notification.alertBody = @"ExpirationHandler";
		[application presentLocalNotificationNow:notification];
	}];
}

- (void)loop:(NSUInteger)i {
	[self.loggingViewController log:@"loop: %i", i];
	double delayInSeconds = 20.0;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		[self loop:i+1];
	});
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[self.loggingViewController log:@"%@:%@", self, NSStringFromSelector(_cmd)];
	UILocalNotification *notification = [UILocalNotification new];
	notification.alertBody = @"applicationWillTerminate:";
	[application presentLocalNotificationNow:notification];
}

@end

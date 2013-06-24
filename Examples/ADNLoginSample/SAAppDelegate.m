//
//  SAAppDelegate.m
//  ADNLoginSample
//
//  Created by Bryan Berg on 6/14/13.
//  Copyright (c) 2013 Mixed Media Labs, Inc. All rights reserved.
//

#import "SAAppDelegate.h"

#import "SAViewController.h"
#import "SALoggedInViewController.h"


@implementation SAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	ADNLogin *adnLogin = [ADNLogin sharedInstance];
	adnLogin.delegate = self;
	adnLogin.scopes = @[@"stream"];

    // Override point for customization after application launch.
	self.viewController = [[SAViewController alloc] initWithNibName:@"SAViewController" bundle:nil];
	self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
	
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	return [[ADNLogin sharedInstance] openURL:url sourceApplication:sourceApplication annotation:annotation];
}

#pragma mark - ADNLoginDelegate

- (void)adnLoginDidFailWithError:(NSError *)error {
	NSLog(@"Login failed with message: %@", error);
}

- (void)adnLoginDidSucceedForUserWithID:(NSString *)userID username:(NSString *)username token:(NSString *)accessToken {
	// Stash token in Keychain, make client request with ADNKit, etc.

	SALoggedInViewController *loggedInViewController = [[SALoggedInViewController alloc] initWithNibName:@"SALoggedInViewController" bundle:nil];
	loggedInViewController.text = [NSString stringWithFormat:@"Username: @%@", username];
	self.window.rootViewController = loggedInViewController;
}

@end

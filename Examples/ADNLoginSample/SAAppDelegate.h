//
//  SAAppDelegate.h
//  ADNLoginSample
//
//  Created by Bryan Berg on 6/14/13.
//  Copyright (c) 2013 Mixed Media Labs, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ADNLogin.h"

@class SAViewController;

@interface SAAppDelegate : UIResponder <UIApplicationDelegate, ADNLoginDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SAViewController *viewController;

@end

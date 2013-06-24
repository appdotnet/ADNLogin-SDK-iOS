//
//  SAViewController.h
//  ADNLoginSample
//
//  Created by Bryan Berg on 6/14/13.
//  Copyright (c) 2013 Mixed Media Labs, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADNPassportLaunchView.h"


@interface SAViewController : UIViewController<ADNPassportLaunchViewDelegate>

@property (assign, nonatomic) BOOL passportLaunchViewShown;
@property (weak, nonatomic) ADNPassportLaunchView *passportLaunchView;

@end

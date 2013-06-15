//
//  SAViewController.h
//  ADNLoginSample
//
//  Created by Bryan Berg on 6/14/13.
//  Copyright (c) 2013 Mixed Media Labs, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADNLoginView.h"

@interface SAViewController : UIViewController<ADNLoginViewDelegate>

@property (assign, nonatomic) BOOL loginViewShown;
@property (weak, nonatomic) ADNLoginView *loginView;

@end

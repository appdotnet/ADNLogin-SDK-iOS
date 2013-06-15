//
//  SALoggedInViewController.h
//  ADNLoginSample
//
//  Created by Bryan Berg on 6/14/13.
//  Copyright (c) 2013 Mixed Media Labs, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SALoggedInViewController : UIViewController

@property (strong, nonatomic) NSString *text;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@end

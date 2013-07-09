//
//  SALoggedInViewController.h
//  ADNLoginSample
//
//  Created by Bryan Berg on 6/14/13.
//  Copyright (c) 2013 Mixed Media Labs, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SALoggedInViewController : UIViewController

- (IBAction)findFriendsClicked:(id)sender;
- (IBAction)inviteFriendsClicked:(id)sender;
- (IBAction)recommendedUsersClicked:(id)sender;

@property (strong, nonatomic) NSString *text;

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *findFriendsButton;
@property (weak, nonatomic) IBOutlet UIButton *inviteFriendsButton;
@property (weak, nonatomic) IBOutlet UIButton *recommendedUsersButton;

@end

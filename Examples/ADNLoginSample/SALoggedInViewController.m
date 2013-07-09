//
//  SALoggedInViewController.m
//  ADNLoginSample
//
//  Created by Bryan Berg on 6/14/13.
//  Copyright (c) 2013 Mixed Media Labs, Inc. All rights reserved.
//

#import "SALoggedInViewController.h"
#import "ADNLogin.h"


@implementation SALoggedInViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.usernameLabel.text = self.text;

	self.findFriendsButton.enabled = [ADNLogin sharedInstance].findFriendsAvailable;
	self.inviteFriendsButton.enabled = [ADNLogin sharedInstance].inviteFriendsAvailable;
	self.recommendedUsersButton.enabled = [ADNLogin sharedInstance].recommendedUsersAvailable;
}

- (IBAction)findFriendsClicked:(id)sender {
	[[ADNLogin sharedInstance] launchFindFriends];
}

- (IBAction)inviteFriendsClicked:(id)sender {
	[[ADNLogin sharedInstance] launchInviteFriends];
}

- (IBAction)recommendedUsersClicked:(id)sender {
	[[ADNLogin sharedInstance] launchRecommendedUsers];
}

@end

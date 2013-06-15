//
//  SAViewController.m
//  ADNLoginSample
//
//  Created by Bryan Berg on 6/14/13.
//  Copyright (c) 2013 Mixed Media Labs, Inc. All rights reserved.
//

#import "SAViewController.h"

#import "ADNLogin.h"

@interface SAViewController ()

@end

@implementation SAViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	ADNLoginView *loginView = [[ADNLoginView alloc] initWithFrame:CGRectZero];
	loginView.delegate = self;
	[self.view addSubview:loginView];
	self.loginView = loginView;

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adnLoginDidEndPolling:) name:kADNLoginDidEndPollingNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	if (!self.loginViewShown) {
		self.loginViewShown = YES;
		[self.loginView animateToVisibleStateWithCompletion:nil];
	}
}

- (void)viewDidUnload {
	[super viewDidUnload];

	self.loginViewShown = NO;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Observers

- (void)adnLoginDidEndPolling:(NSNotification *)notification {
	[self.loginView animateToVisibleStateWithCompletion:nil];
}

#pragma mark - ADNLoginViewDelegate

- (void)adnLoginViewDidRequestInstall:(ADNLoginView *)loginView {
	[self.loginView animateToPollingStateWithCompletion:nil];

	[[ADNLogin sharedInstance] passportProductViewControllerWithCompletionBlock:^(SKStoreProductViewController *storeViewController, BOOL result, NSError *error) {
		if (error == nil) {
			[self presentViewController:storeViewController animated:YES completion:nil];
		} else {
			NSLog(@"Error loading store: %@", error);
		}
	}];
}

- (void)adnLoginViewDidRequestLogin:(ADNLoginView *)loginView {
	[[ADNLogin sharedInstance] login];
}

@end

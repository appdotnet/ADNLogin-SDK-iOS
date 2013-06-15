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

	ADNPassportLaunchView *passportLaunchView = [[ADNPassportLaunchView alloc] initWithFrame:CGRectZero];
	passportLaunchView.delegate = self;
	[self.view addSubview:passportLaunchView];
	self.passportLaunchView = passportLaunchView;

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adnLoginDidEndPolling:) name:kADNLoginDidEndPollingNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	if (!self.passportLaunchViewShown) {
		self.passportLaunchViewShown = YES;
		[self.passportLaunchView animateToVisibleStateWithCompletion:nil];
	}
}

- (void)viewDidUnload {
	[super viewDidUnload];

	self.passportLaunchViewShown = NO;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Observers

- (void)adnLoginDidEndPolling:(NSNotification *)notification {
	[self.passportLaunchView animateToVisibleStateWithCompletion:nil];
}

#pragma mark - ADNPassportLaunchViewDelegate

- (void)adnPassportLaunchViewDidRequestInstall:(ADNPassportLaunchView *)passportLaunchView {
	[self.passportLaunchView animateToPollingStateWithCompletion:nil];

	[[ADNLogin sharedInstance] passportProductViewControllerWithCompletionBlock:^(SKStoreProductViewController *storeViewController, BOOL result, NSError *error) {
		if (error == nil) {
			[self presentViewController:storeViewController animated:YES completion:nil];
		} else {
			NSLog(@"Error loading store: %@", error);
		}
	}];
}

- (void)adnPassportLaunchViewDidRequestLogin:(ADNPassportLaunchView *)passportLaunchView {
	[[ADNLogin sharedInstance] login];
}

@end

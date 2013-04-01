//
//  ADNLogin.m
//  ADNSDK
//
//  Created by Bryan Berg on 3/28/13.
//  Copyright (c) 2013 Mixed Media Labs, Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this
//  software and associated documentation files (the "Software"), to deal in the Software
//  without restriction, including without limitation the rights to use, copy, modify,
//  merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or
//  substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
//  BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
//  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "ADNLogin.h"

#ifndef ADNLOGIN_SDK_SCHEME
	#define ADNLOGIN_SDK_SCHEME @""
#endif

static NSString *const kADNLoginSDKScheme = ADNLOGIN_SDK_SCHEME;
static NSString *const kADNLoginURLNamePrefix = @"net.app.client.";

static NSString *const kADNLoginSignupAvailablePListURL = @"https://account.app.net/adnlogin/signupavailable?platform=ios&client_id=%@&scheme=%@";
static NSString *const kADNLoginAppInstallURL = @"itms-apps://itunes.apple.com/us/app/id534414475";

static NSString *const kADNLoginMissingURLSchemeErrorMessage = @"ADNLogin URL scheme must be in the format 'adnNNNNsuffix'";

@interface ADNLogin ()

@property (strong, nonatomic) NSString *clientID;
@property (assign, nonatomic) NSInteger appPK;
@property (strong, nonatomic) NSString *primaryScheme;
@property (strong, nonatomic) NSString *schemeSuffix;

@property (readonly, nonatomic) NSString *loginScheme;

@end

@implementation ADNLogin

static NSString *queryStringEscape(NSString *string, NSStringEncoding encoding) {
    static NSString *const kAFCharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    static NSString *const kAFCharactersToLeaveUnescaped = @"[].";

	return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, (__bridge CFStringRef)kAFCharactersToLeaveUnescaped, (__bridge CFStringRef)kAFCharactersToBeEscaped, CFStringConvertNSStringEncodingToEncoding(encoding));
}

static NSString *queryStringForParameters(NSDictionary *parameters) {
	NSMutableArray *a = [NSMutableArray arrayWithCapacity:[parameters count]];
	[parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		[a addObject:[NSString stringWithFormat:@"%@=%@",
					  queryStringEscape(key, NSUTF8StringEncoding),
					  queryStringEscape(obj, NSUTF8StringEncoding)]];
	}];

	return [a componentsJoinedByString:@"&"];
}

static NSDictionary *parametersForQueryString(NSString *queryString) {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	NSArray *items = [queryString componentsSeparatedByString:@"&"];
	for (NSString *item in items) {
		NSArray *keyAndValue = [item componentsSeparatedByString:@"="];
		if (keyAndValue.count == 2) {
			NSString *key = [keyAndValue[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			NSString *value = [keyAndValue[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

			parameters[key] = value;
		}
	}

	return parameters;
}

- (instancetype)init {
	self = [super init];
	if (self) {
		self.clientID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ADNLoginClientID"];
		self.schemeSuffix = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ADNLoginSchemeSuffix"];

		NSArray *urlTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
		for (NSDictionary *urlType in urlTypes) {
			NSString *urlName = urlType[@"CFBundleURLName"];
			if ([urlName hasPrefix:kADNLoginURLNamePrefix]) {
				// hit
				NSArray *urlShemes = urlType[@"CFBundleURLSchemes"];
				self.clientID = [urlName substringFromIndex:[kADNLoginURLNamePrefix length]];
				self.primaryScheme = [urlShemes lastObject];

				if (self.primaryScheme.length) {
					NSScanner *schemeScanner = [NSScanner scannerWithString:self.primaryScheme];
					if (![schemeScanner scanString:@"adn" intoString:NULL]) {
						[NSException raise:kADNLoginMissingURLSchemeErrorMessage format:nil];
					}

					// possibly scan over "dev" or "beta" if it's there
					[schemeScanner scanString:kADNLoginSDKScheme intoString:NULL];

					NSInteger appPK = 0;

					if (![schemeScanner scanInteger:&appPK]) {
						[NSException raise:kADNLoginMissingURLSchemeErrorMessage format:nil];
					}

					self.appPK = appPK;
					NSString *suffix;

					[schemeScanner scanCharactersFromSet:[NSCharacterSet lowercaseLetterCharacterSet]
												  intoString:&suffix];

					self.schemeSuffix = suffix;

					if (![schemeScanner isAtEnd]) {
						[NSException raise:kADNLoginMissingURLSchemeErrorMessage format:nil];
					}

					break;
				}
			}
		}

		if (!self.clientID.length || !self.primaryScheme.length) {
			[NSException raise:kADNLoginMissingURLSchemeErrorMessage format:nil];
		}
	}

	return self;
}

- (BOOL)canOpenURLWithScheme:(NSString *)scheme {
	return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@://test-install", scheme]]];
}

- (NSString *)loginScheme {
	NSArray *schemes;

	if (kADNLoginSDKScheme.length) {
		schemes = @[[NSString stringWithFormat:@"adnlogin%@", kADNLoginSDKScheme]];
	} else {
		schemes = @[@"adnloginbeta", @"adnlogin"];
	}

	for (NSString *scheme in schemes) {
		if ([self canOpenURLWithScheme:scheme]) {
			return scheme;
		}
	}

	return nil;
}

- (BOOL)isLoginAvailable {
	return (BOOL)self.loginScheme.length;	
}

- (void)pollForSignupAvailableWithCompletionBlock:(ADNLoginSignupAvailableCompletionBlock)completionBlock {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		BOOL value = NO;

		if (self.loginAvailable) {
			NSString *signupPlistURL = [NSString stringWithFormat:kADNLoginSignupAvailablePListURL, self.clientID, kADNLoginSDKScheme];
			// TODO: make this asynchronous instead of blocking
			NSDictionary *signupAvailabilityDictionary = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:signupPlistURL]];
			if ([signupAvailabilityDictionary[@"SignupAvailable"] isEqualToValue:[NSNumber numberWithBool:YES]]) {
				value = YES;
			}
		}

		if (completionBlock) {
			dispatch_async(dispatch_get_main_queue(), ^{
				completionBlock(value);
			});
		}
	});
}

- (BOOL)loginWithScopes:(NSArray *)scopes {
	NSString *scopeString = [scopes componentsJoinedByString:@" "] ?: @"";
	NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:self.clientID, @"client_id",
								scopeString, @"scope",
								[NSString stringWithFormat:@"%u", self.appPK], @"app_pk",
								self.schemeSuffix, @"suffix", nil];

	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://token?%@", self.loginScheme, queryStringForParameters(parameters)]];

	if ([[UIApplication sharedApplication] canOpenURL:url]) {
		[[UIApplication sharedApplication] openURL:url];

		return YES;
	}

	return NO;
}

- (BOOL)handleOpenURL:(NSURL *)url {
	if ([url.scheme isEqualToString:self.primaryScheme]) {
		NSDictionary *parameters = parametersForQueryString(url.fragment);
		NSString *accessToken = parameters[@"access_token"];
		if (accessToken) {
			dispatch_async(dispatch_get_main_queue(), ^{
				[self.delegate adnLoginDidSucceedWithToken:accessToken];
			});
		} else {
			NSString *error = parameters[@"error"] ?: @"Error logging in.";
			dispatch_async(dispatch_get_main_queue(), ^{
				[self.delegate adnLoginDidFailWithMessage:error];
			});
		}

		return YES;
	}

	NSLog(@"Couldn't open URL");

	return NO;
}

- (BOOL)installLoginApp {
	return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kADNLoginAppInstallURL]];
}

@end

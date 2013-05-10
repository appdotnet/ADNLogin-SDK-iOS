//
//  ADNLogin.h
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

#import <Foundation/Foundation.h>

@class ADNLogin;

typedef void (^ADNLoginSignupAvailableCompletionBlock)(BOOL available);

static NSString *const kADNLoginErrorDomain = @"ADNLoginErrorDomain";

/**
 The `ADNLoginDelegate` protocol defines the methods the ADNLogin SDK will use to communicate state with your app. Typically this will be implemented by your app delegate.
 */
@protocol ADNLoginDelegate <NSObject>

/**
 Called when fast-switching back from the App.net app with valid login credentials.
 
 @param userID The user ID of the logged-in user.
 @param accessToken An access token authorized with the requested permissions.
*/
- (void)adnLoginDidSucceedForUserWithID:(NSString *)userID token:(NSString *)accessToken;

/**
 Called when login has failed.

 @param error An error describing the reason for failure.
*/
- (void)adnLoginDidFailWithError:(NSError *)error;

@optional

/**
 Called when app was launched from App.net Passport.
 (Optional. App will still be launchable if this method isn't defined.)
 */
- (void)adnLoginDidLaunchFromPassport;

@end


/**
 The primary object in the ADNLogin SDK. Generally, you will create an instance of this and store it on your app delegate.
 */
@interface ADNLogin : NSObject

/**
 The SDK delegate.
 */
@property (weak, nonatomic) NSObject<ADNLoginDelegate> *delegate;

/**
 Whether or not ADNLogin-assisted authentication is available. This can be used to detect whether the App.net app is installed. If this is `NO`, your app should fall back to another login method, like the password flow.
 */
@property (readonly, nonatomic, getter=isLoginAvailable) BOOL loginAvailable;


/**
 Request login.
 
 @param scopes A list of the requested authentication scopes.
 
 @return `YES` if the App.net was launched to request login, `NO` if it was not installed or unable to open
 */
- (BOOL)loginWithScopes:(NSArray *)scopes;
 
/**
 Call this method from your app delegate's `application:openURL:sourceApplication:annotation:` method.
 
 @param url The URL of the request
 @param sourceApplication The bundle ID of the opening application
 @param annotation The supplied annotation
 
 @return `YES` if the ADNLogin SDK handled the request, `NO` if it did not
 */
- (BOOL)openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

/**
 Determine whether signup (without an invite) is currently available. Signup with invite link is always available in the app.

 @param completionBlock Block to be called with the result of the signup availability check.
 
 @discussion Makes a network call on a background thread.
 */
- (void)pollForSignupAvailableWithCompletionBlock:(ADNLoginSignupAvailableCompletionBlock)completionBlock;

/**
 Request that the App.net app be installed. Right now, this is designed to open the App Store app via a URL scheme, but may be extended to use StoreKit in the future.
 
 @return `YES` if the App Store app was launched, `NO` if it was unable to open
 */
- (BOOL)installLoginApp;

@end

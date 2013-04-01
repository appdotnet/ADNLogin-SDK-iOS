# ADNLogin-SDK-iOS

This is the (very preliminary) documentation for the App.net Login SDK for iOS. It allows users to forgo entering passwords into each app and instead authorize from the App.net Passport iOS application. This app will allow you to browse the App.net directory and perform account management functions.

## Usage

The SDK is designed to have no other dependencies other than iOS itself. It should work with iOS 5.1+, though use of a modern SDK with ARC and "modern" object literal support is required. (If this is a problem for anyone, we can likely change this.)

Your app will need to define a specific URL scheme in its Info.plist file which will identify it to the login SDK. The "Identifier" of this URL scheme must be set up in a specific way. Here is an example:

* Identifier: `net.app.client.UxUWrSdVLyCaShN62xZR5tknGvAxK93P`
    * ... where `UxUWrSdVLyCaShN62xZR5tknGvAxK93P` is the client ID of the application.
* URL scheme: `adn9281`
    * ... where `9281` is the app ID listed in the app management interface.

![Xcode Info.plist editor screenshot](https://files.app.net/1/34450/a_mk_VrbaUl2WRLeE5vVbZ--R0WdluIo80CxSZ9NC1d1t35Mwbh9HjR6_jrPQSbamKvINn06ztwICNYpJoMhzHwHTqP7laHmXdWC4_vvRAFrpcpBfpXoWtwH77ohNePRsm0b-rhsnFjvzaSRniK_OPkUqf5H1Ai2z7CAhSHjP3Ek)

Multiple apps which share the same App.net client ID but which are represented by different applications in the iOS app store should suffix the designated URL scheme for alternate versions with an app-unique identifier, e.g., "ipad" for the iPad version of an application. This suffix should match with the information entered in the app management interface on App.net.

In your app delegate's header file, import ADNLogin.h, have your delegate implement the ADNLoginDelegate protocol, and add a property to hold onto the ADNLogin object.

```objc
#import "ADNLogin.h"

@interface SLAppDelegate : UIResponder <UIApplicationDelegate, ADNLoginDelegate>

@property (strong, nonatomic) ADNLogin *adn;

...

@end
```

In your app delegate's .m file, instantiate the SDK:

```objc
@implementation SLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	self.adn = [[ADNLogin alloc] init];
	self.adn.delegate = self;

...
```

Ensure that the login SDK has the opportunity to handle any open URL which comes back:

```objc
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	return [self.adn handleOpenURL:url];
 }
```

Implement the ADNLoginDelegate protocol methods:

```objc
#pragma mark - ADNLoginDelegate

- (void)adnLoginDidSucceedWithToken:(NSString *)accessToken {
    // ... do some stuff
}

- (void)adnLoginDidFailWithMessage:(NSString *)errorMessage {
    // ... and here too
}
```

Of course, please feel free to deviate from these directions if you know what you're doing. ;) Everyone has their own habits and preferences when it comes to code -- and that seems to be especially true for ObjC.

Feedback welcome.

## License

    Copyright (c) 2013 Mixed Media Labs, Inc. All rights reserved.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this
    software and associated documentation files (the "Software"), to deal in the Software
    without restriction, including without limitation the rights to use, copy, modify,
    merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or
    substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
    BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
    NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
    DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

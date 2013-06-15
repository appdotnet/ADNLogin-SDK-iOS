# ADNLogin-SDK-iOS

This is the documentation for the App.net Login SDK for iOS. It allows users to forgo entering passwords into each app and instead authorize from the App.net Passport iOS application. This app allows you to browse the App.net directory and perform account management functions.

## Usage

The SDK is designed to have no other dependencies other than iOS itself. It should work with iOS 5.1+, though use of a modern SDK with ARC and "modern" object literal support is required. (If this is a problem for anyone, we can likely change this.)

Your app will need to define a specific URL scheme in its Info.plist file which will identify it to the login SDK. The "Identifier" of this URL scheme must be set up in a specific way. Here is an example:

![App.net app management screenshot](https://files.app.net/1/66391/alRIGbbAO-F-mipHbxjQNU78eqZevQNlZinRToWKopnJ82S53arm0Ukm8IDmzexf9k-EpQNfAg2y21SrUnZT2Wn4UwepcDGlGlxylvgi1B26hE7koxYsxUp3kp_RZCbccRdBATHD1LzIDkgoAneqEuv6lasZefTQ16C0oxnr49kE)

Should be entered into the URL scheme editor this way:

![Xcode Info.plist editor screenshot](https://files.app.net/1/34450/a_mk_VrbaUl2WRLeE5vVbZ--R0WdluIo80CxSZ9NC1d1t35Mwbh9HjR6_jrPQSbamKvINn06ztwICNYpJoMhzHwHTqP7laHmXdWC4_vvRAFrpcpBfpXoWtwH77ohNePRsm0b-rhsnFjvzaSRniK_OPkUqf5H1Ai2z7CAhSHjP3Ek)

Often, developers create multiple apps which share the same App.net client ID but which are represented by different applications in the iOS app store. Each application in iTunes should have the URL scheme for alternate versions with an app-unique identifier, e.g., "ipad" for the iPad version of an application. This suffix should match with the information entered in the app management interface on App.net.

Each bundle ID must be associated with an App.net application and directory page. You must go and create a Directory Page for your app on its settings page in the developer management interface here: https://account.app.net/developer/apps/ (click into the app, look for "Create Page", complete the form. You do not need to make your page public in order to use the SDK.) **If you receive the "Failed to load authorize dialog" error, this is most likely the problem.**

In your app delegate's header file, import ADNLogin.h and have your delegate implement the ADNLoginDelegate protocol.

```objc
#import "ADNLogin.h"

@interface SLAppDelegate : UIResponder <UIApplicationDelegate, ADNLoginDelegate>

...

@end
```

In your app delegate's .m file, instantiate the SDK, and set the authorization scopes your app will request:

```objc
@implementation SLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ADNLogin *adn = [ADNLogin sharedInstance];
    adn.delegate = self;
    adn.scopes = @[@"stream"];

...
```

Ensure that the login SDK has the opportunity to handle any open URL which comes back:

```objc
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self.adn openURL:url sourceApplication:sourceApplication annotation:annotation];
 }
```

Implement the ADNLoginDelegate protocol methods:

```objc
#pragma mark - ADNLoginDelegate

- (void)adnLoginDidSucceedForUserWithID:(NSString *)userID username:(NSString *)username token:(NSString *)accessToken {
    // Stash token in Keychain, make client request with ADNKit, etc.
}

- (void)adnLoginDidFailWithError:(NSError *)error {
    // Report error to user.
    // App.net Passport 1.0.474 does not currently call this method, but newer versions will.
}
```

Credential storage is currently out of scope of the SDK. Please be sure to store credentials securely, i.e., in the Keychain as opposed to being stashed in NSUserDefaults. We suggest [SSKeychain](https://github.com/soffes/sskeychain) for this purpose.

Also included is a sample view for launching App.net Passport (which you may wish to subclass and style) and a sample application demonstrating the use of the ADNLogin SDK.

Of course, please feel free to deviate from these directions if you know what you're doing. ;) Everyone has their own habits and preferences when it comes to code -- and that seems to be especially true for ObjC.

Feedback welcome.

Feel free to drop into the [App.net Developer Patter room](http://patter-app.net/room.html?channel=1383) if you need help.

## License

MIT. See LICENSE file included in repository.

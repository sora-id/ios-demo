# Sora iOS Demo
This app is a sample demo of the Sora ID verification flow for iOS

![Sora Verification Flow](https://files.readme.io/03e4657-Simulator_Screen_Shot_-_iPhone_X_15.2_-_2022-04-12_at_13.11.04.png)

## Quickstart
To quickly test out the verification flow you can clone the app from:
https://github.com/sora-id/sora-ios-demo
Open the app in Xcode and set navigate to the SoraiOSDemo--iOS--Info.plist file and set the API_KEY, PROJECT_ID, and BASE_URL fields. You can now run the app.

> ⚠️ **Security Note**: For a production system, do not embed this key in the client side application. Requests to Sora’s API should only be performed on your backend servers.!

## Deep dive
The demo app implements the following steps to validate a user:
 - Fetches a verification session from Sora
 - Launches a web view for the user to put in their information
 - If successful, a redirect with the custom soraid:// scheme is made with a verification token
 - The app then uses that token to retrieve the users information

## The demo app is broken down into these parts:

### API:
- Handles calling the APIs for the verification flow. To call these APIs you will have to pass the API Key as a header
```json
"Authorization: Bearer <API_KEY>"
```
- createSession: Fetches a token from the /v1/verification_sessions that can be used to embed a verification webView. To receive the deep link you will have to pass this as a payload:
```json
"{\"is_webview\": \"true\"}"
```
- You must also include the project ID in the payload.
- retrieveUser: After getting the token from createSession pass it as a query parameter to get the verified data.

### PList:
- Helper class to fetch the API_KEY and BASE_URL values from the plist file

### ContentView:
- UI to trigger the WebView
- Accepts deep links
- For better readability ContentView is extended to ContentView+CreateSession and ContentView+Verification

#### ContentView+CreateSession:
- createSession: Calls the createSession in the API class and triggers the webView with the verification page

#### ContentView+Verification:
- processDeepLink: this parses the soraid:// deep links and checks the status. If it’s a success the WebView redirects to soraid://success and the retrieveUser function is called. Ensure that `soraid` is included in your URL scheme configuration.
- parseVerification: If the retrieveUser call is successful retrieveUser  will return a JSON of the users retrieved verified data. ContentView will then display this data

### WebView:
- This UIViewRepresentable extendable embeds the verification flow and handling the soraid:// redirect. 

### Selfie Verification
Sora uses iProov for selfie verification. You will need to perform the following steps in your native application. You can clone our sample application or install these changes yourself.
### Step 1: Install the package

Integration with your app is supported via CocoaPods, Swift Package Manager, and Carthage. You can also install the SDK manually in Xcode without the use of any dependency manager (this is not recommended).

#### CocoaPods

> Note: The SDK is distributed as an XCFramework, therefore you are required to use CocoaPods 1.9.0 or newer.
> 
1. If you are not yet using CocoaPods in your project, first run `sudo gem install cocoapods` followed by `pod init`. (For further information on installing CocoaPods, [click here](https://guides.cocoapods.org/using/getting-started.html#installation).)
2. Add the following to your Podfile (inside the target section):
    
    ```
    pod 'iProov'
    ```
    
3. Add the following to the bottom of your Podfile:
    
    ```
    post_install do |installer|
      installer.pods_project.targets.each do |target|
        if ['iProov', 'Starscream'].include? target.name
          target.build_configurations.each do |config|
              config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
          end
        end
      end
    end
    ```
    
4. Run `pod install`.

#### Swift Package Manager

> Note: If your app has an existing dependency on Starscream, you must either remove that existing dependency and use the iProov-supplied versions, or should avoid installing iProov via SPM and instead use one of the other installation methods.
> 

#### Installing via Xcode

1. Select `File` → `Add Packages…` in the Xcode menu bar.
2. Search for the iProov SDK package using the following URL:
    
    ```
    https://github.com/iProov/ios
    
    ```
    
3. Set the *Dependency Rule* to be *Up to Next Major Version* and input 11.0.0-beta2 as the lower bound.
4. Click *Add Package* to add the iProov SDK to your Xcode project and then click again to confirm.

#### Installing via Package.swift

If you prefer, you can add iProov via your Package.swift file as follows:

```
.package(
	name: "iProov",
	url: "https://github.com/iProov/ios.git",
	.upToNextMajor(from: "11.0.0-beta2")
),
```

Then add `iProov` to the `dependencies` array of any target for which you wish to use iProov.

#### Carthage

> Note: You are strongly advised to use Carthage v0.38.0 or above, which has full support for pre-built XCFrameworks, however older versions of Carthage are still supported (but you must use traditional universal/"fat" frameworks instead).
> 
1. Add the following to your Cartfile:
    
    ```
    binary "https://raw.githubusercontent.com/iProov/ios/master/carthage/IProov.json"
    github "daltoniam/Starscream" >= 4.0.0
    
    ```
    
2. Create the following script named *carthage.sh* in your root Carthage directory:
    
    ```
    # carthage.sh
    # Usage example: ./carthage.sh build --platform iOS
    
    set -euo pipefail
    
    xcconfig=$(mktemp /tmp/static.xcconfig.XXXXXX)trap 'rm -f "$xcconfig"' INT TERM HUP EXIT
    
    if [[ "$@" != *'--use-xcframeworks'* ]]; then
    	# See https://github.com/Carthage/Carthage/blob/master/Documentation/Xcode12Workaround.md for further details
    
    	CURRENT_XCODE_VERSION="$(xcodebuild -version | grep "Xcode" | cut -d' ' -f2 | cut -d'.' -f1)00"
    	CURRENT_XCODE_BUILD=$(xcodebuild -version | grep "Build version" | cut -d' ' -f3)echo "EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_simulator__NATIVE_ARCH_64_BIT_x86_64__XCODE_${CURRENT_XCODE_VERSION}__BUILD_${CURRENT_XCODE_BUILD} = arm64 arm64e armv7 armv7s armv6 armv8" >> $xcconfig
    	echo 'EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_simulator__NATIVE_ARCH_64_BIT_x86_64__XCODE_'${CURRENT_XCODE_VERSION}' = $(EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_simulator__NATIVE_ARCH_64_BIT_x86_64__XCODE_$(XCODE_VERSION_MAJOR)__BUILD_$(XCODE_PRODUCT_BUILD_VERSION))' >> $xcconfig
    	echo 'EXCLUDED_ARCHS = $(inherited) $(EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_$(EFFECTIVE_PLATFORM_SUFFIX)__NATIVE_ARCH_64_BIT_$(NATIVE_ARCH_64_BIT)__XCODE_$(XCODE_VERSION_MAJOR))' >> $xcconfig
    fi
    
    echo 'BUILD_LIBRARY_FOR_DISTRIBUTION=YES' >> $xcconfig
    
    export XCODE_XCCONFIG_FILE="$xcconfig"
    carthage "$@"
    ```
    
    This script contains two important workarounds:
    
    1. When building universal ("fat") frameworks, it ensures that duplicate architectures are not lipo'd into the same framework when building on Apple Silicon Macs, in accordance with [the official Carthage workaround](https://github.com/Carthage/Carthage/blob/master/Documentation/Xcode12Workaround.md) (note that the document refers to Xcode 12 but it also applies to Xcode 13 and 14).
    2. It ensures that the Starscream framework is built with the `BUILD_LIBRARY_FOR_DISTRIBUTION` setting enabled.
3. Make the script executable:
    
    ```
    chmod +x carthage.sh
    ```
    
4. You must now use `./carthage.sh` instead of `carthage` to build the dependencies.
    
    **Carthage 0.38.0 and above (use XCFrameworks):**
    
    ```
    ./carthage.sh update --use-xcframeworks --platform ios
    ```
    
    **Carthage 0.37.0 and below (use universal frameworks):**
    
    ```
    ./carthage.sh update --platform ios
    ```
    
5. Add the built .framework/.xcframework files from the *Carthage/Build* folder to your project in the usual way.
    
    **Carthage 0.37.0 and below only:**
    
    You should follow the additional instructions [here](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos) to remove simulator architectures from your universal binaries prior to running your app/submitting to the App Store.
    

### Step 2: Update your app

- Use `import iProov` in the file where your `WKWebView` is declared.

- Make sure your `WKWebviewConfiguration` contains the following settings:

```json
webConfiguration.requiresUserActionForMediaPlayback = false
webConfiguration.allowsInlineMediaPlayback = true
webConfiguration.mediaTypesRequiringUserActionForPlayback = []
```

- As early as possible in the lifecycle of your `WKWebView` (e.g. in your view controller's `viewDidLoad` method), call `webView.installIProovNativeBridge()`.
  

### Error:
- Helper class to return an NSError
- keyError - if the API_KEY or PROJECT_ID field is missing from the .plist file
- invalidURLError - if the BASE_URL is missing or malformed

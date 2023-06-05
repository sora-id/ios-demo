# Sora iOS Demo
This app is a sample demo of the Sora ID verification flow for iOS

![Sora Verification Flow](https://files.readme.io/03e4657-Simulator_Screen_Shot_-_iPhone_X_15.2_-_2022-04-12_at_13.11.04.png)

## Quickstart
To quickly test out the verification flow you can clone the app from:
https://github.com/sora-id/sora-ios-demo
Open the app in Xcode and set navigate to the SoraiOSDemo--iOS--Info.plist file and set the API_KEY and BASE_URL fields. You can now run the app.

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
- If you intend to use selfie verification in your integration, ensure that the following fields are set in your `WKWebView` configuration:
```
let webConfiguration = WKWebViewConfiguration()
webConfiguration.allowsInlineMediaPlayback = true
webConfiguration.mediaTypesRequiringUserActionForPlayback = []
```

### Error:
- Helper class to return an NSError
- keyError - if the API_KEY field is missing from the .plist file
- invalidURLError - if the BASE_URL is missing or malformed

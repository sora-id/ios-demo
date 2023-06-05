//
//  WebView.swift
//  SoraiOSDemo
//
//  Created by Sora ID on 3/2/22.
//
//  This WebView handles embedding the verification flow and handling the soraid:// redirect

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
 
    @Binding var url: URL?
 
    func makeUIView(context: Context) -> WKWebView {
        let webConfiguration = WKWebViewConfiguration()
        // <-- REQUIRED for selfie verification -->
        webConfiguration.allowsInlineMediaPlayback = true
        webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        // < -- >
        let webView = WKWebView(frame: CGRect(), configuration: webConfiguration)
        // If selfie verification isn't needed, webView can be initialized like this:
        // let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        if let url = url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func makeCoordinator() -> WebView.Coordinator {
        Coordinator(self)
    }
    
    //Corrdinators are the SwiftUI way of implementing delegates
    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url,
                !url.absoluteString.hasPrefix("http://"),
                !url.absoluteString.hasPrefix("https://"),
                UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    decisionHandler(.cancel)
            }
            else {
                // This allows the WebView to handle deep links correctly
                // In the demo implementation it triggers the users verified data
                decisionHandler(.allow)
            }
        }
    }
}

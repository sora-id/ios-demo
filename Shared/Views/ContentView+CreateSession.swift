//
//  ContentView+CreateSession.swift
//  SoraiOSDemo (iOS)
//
//  Created by Sora ID on 3/10/22.
//

import SwiftUI

extension ContentView {
    
    /// Calls the /v1/verification_sessions endpoint using the API_KEY stored in the plist.
    /// A successful call returns a token which can then be used to embed a webview
    func createSession() {
        API.shared.createSession { data, error in
            if error == nil {
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
                    
                    guard let token = jsonResult?["token"] else {
                        showingAlert = true
                        return
                    }
                    
                    let urlString = PList.shared.getBaseURL()
                    
                    if urlString == nil {
                        showingAlert = true
                    }
                    
                    else {
                        isShowVerifyButton = true
                        url = URL(string: "\(urlString!)verify/?token=\(token)")
                        isShowWebView.toggle()
                    }
                } catch {
                    showingAlert = true
                }
            }
            
            else {
                showingAlert = true
            }
        }
    }
}

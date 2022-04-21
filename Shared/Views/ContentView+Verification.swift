//
//  ContentView+FetchVerification.swift
//  SoraiOSDemo (iOS)
//
//  Created by Sora ID on 3/10/22.
//

import SwiftUI

extension ContentView {
    
    /// Calls the /v1/verification_sessions endpoint to fetch the users verification data
    func processDeepLink(_ url: URL) {
        let urlString = url.absoluteString.components(separatedBy: "soraid://")
        if urlString.count > 1 {
            let parameters = urlString[1]
            if parameters.contains("success") {
                isShowVerifyButton = false
                isShowWebView = false
                API.shared.retrieveUser(verificationID: String(verificationID)) { data, error in
                    if let data = data {
                        parseVerification(data: data)
                    }
                    else {
                        showingAlert = true
                    }
                }
            }
            else if parameters.contains("exit") {
                isShowWebView = false
                showingAlert = true
            }
        }
    }
    
    /// Helper function to parse the /v1/verification_sessions response and populates the content view with that data
    func parseVerification(data: Data) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            if let jsonDict = jsonObject as? NSDictionary {
                if let status = jsonDict["status"] as? String {
                    verifiedStatus = status
                    verificationResponse = String(decoding: data, as: UTF8.self)
                    isVerified = true
                    isShowVerifyButton = false
                }
                else {
                    showingAlert = true
                }
            }
        } catch {
            showingAlert = true
        }
    }
}

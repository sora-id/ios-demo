//
//  ContentView.swift
//  Shared
//
//  Created by Sora ID on 3/2/22.
//

import SwiftUI
import WebKit

struct ContentView: View {
    
    @State var isShowWebView = false
    @State var url: URL?
    @State var verificationResponse = ""
    @State var showingAlert = false
    @State var isShowVerifyButton = true
    @State var isVerified = false
    @State var verifiedStatus = ""
    @State var verificationID = ""
    
    var body: some View {
        NavigationView {
            VStack {
                if isVerified {
                    Text("Verification response")
                        .font(.headline)
                }
                ScrollView {
                     VStack {
                          Text(verificationResponse)
                               .lineLimit(nil)
                               .font(.system(.body, design: .monospaced))
                     }
                     .frame(maxWidth: .infinity)
                }
                if isShowVerifyButton {
                    Button {
                        // The first step in the flow is to create a session.
                        createSession()
                    } label: {
                        Text("Verify")
                    }
                    .buttonStyle(PrimaryButton())
                }
                else {
                    if isVerified {
                        HStack {
                            if verifiedStatus == "success" {
                                Text("✅")
                            }
                            else if verifiedStatus == "failed" || verifiedStatus == "expired" {
                                Text("❌")
                            }
                            else {
                                Text("⌛")
                            }
                            Text("Verification status: \(verifiedStatus)")
                                .font(.headline)
                            Spacer()
                        }
                    }
                    else {
                        ProgressView()
                    }
                }
            }
            .padding()
            .navigationBarTitle(Text("Demo App"), displayMode: .inline)
        }
        .alert("Could not fetch data", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        }
        .sheet(isPresented: $isShowWebView) {
            // If a session is created successfully, we can then use the returned token to embed the Sora ID verification page into the WebView
            WebView(url: $url)
        }
        .onOpenURL { redirect in
            // If the WebView detects a soraid:// redirect it triggers the code to fetch the users verification data
            processDeepLink(redirect)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  Errors.swift
//  SoraiOSDemo (iOS)
//
//  Created by Sora ID on 3/7/22.
//

import Foundation

extension NSError {
    static func keyError() -> NSError {
        let userInfo = [NSLocalizedDescriptionKey: "API key not found. Please make sure the 'API Key' value is set in your plist file and that it's added to bundle resources"]
        return NSError(domain: Bundle.main.bundleIdentifier!, code: 401, userInfo: userInfo)
    }

    static func invalidURLError() -> NSError {
        let userInfo = [NSLocalizedDescriptionKey: "Invalid URL"]
        return NSError(domain: Bundle.main.bundleIdentifier!, code: 400, userInfo: userInfo)
    }
}

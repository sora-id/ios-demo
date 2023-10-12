//
//  Plist.swift
//  SoraiOSDemo (iOS)
//
//  Created by Sora ID on 3/7/22.
//
//  A class to handle fetching plist values

import Foundation

enum PListKey: String {
    case url = "BASE_URL"
    case apiKey = "API_KEY"
    case projectId = "PROJECT_ID"
}

class PList {
    
    static let shared = PList()
    
    func getBaseURL() -> String? {
        guard let url = getPlistValue(key: PListKey.url) else {
            print("Please ensure 'BASE_URL' is set in the plist")
            return nil
        }
        return url
    }

    func getAPIKey() -> String? {
        guard let apiKey = getPlistValue(key: PListKey.apiKey) else {
            print("Please ensure 'API_KEY' is set in the plist")
            return nil
        }
        return apiKey
    }
    
    func getProjectID() -> String? {
        guard let projectId = getPlistValue(key: PListKey.projectId) else {
            print("Please ensure 'PROJECT_ID' is set in the plist")
            return nil
        }
        return projectId
    }

    fileprivate func getPlistValue(key: PListKey) -> String? {
        let plistName = "SoraiOSDemo--iOS--Info"
        
        guard let path = Bundle.main.path(forResource: plistName, ofType: "plist") else {
            print("Could not find plist. Make sure it's copied to bundle resources")
            return nil
        }
        
        guard let value = NSDictionary(contentsOfFile: path)?[key.rawValue] else {
            return nil
        }
        
        return value as? String
    }
}

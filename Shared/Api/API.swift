//
//  API.swift
//  SoraiOSDemo
//
//  Created by Sora ID on 3/2/22.
//

import Foundation

fileprivate enum Method: String {
    case get = "GET"
    case post = "POST"
}

class API {
    
    static let shared = API()
    
    func createSession(completionHandler: @escaping (Data?, Error?) -> Void) {
        let payload = "{\"is_webview\": \"true\"}".data(using: .utf8)
        request(payload: payload, method: Method.post, completionHandler: completionHandler)
    }
    
    func retrieveUser(verificationID: String, completionHandler: @escaping (Data?, Error?) -> Void) {
        request(queryParams: verificationID, method: Method.get, completionHandler: completionHandler)
    }
    
    fileprivate func request(queryParams: String? = nil, payload: Data? = nil, method: Method, completionHandler: @escaping (Data?, Error?) -> Void) {
        
        var apiURL = PList.shared.getBaseURL()
        if apiURL == nil {
            let error = NSError.invalidURLError()
            completionHandler(nil, error)
            return
        }
        
        apiURL = "\(apiURL!)v1/verification_sessions"
        
        if let queryParams = queryParams {
            apiURL = "\(apiURL!)/\(queryParams)"
        }
        
        guard let url = URL(string: apiURL!) else {
            completionHandler(nil, NSError.invalidURLError())
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        guard let apiKey = PList.shared.getAPIKey() else {
            let error = NSError.keyError()
            print(error)
            completionHandler(nil, error)
            return
        }
        
        request.addValue("Bearer " + apiKey, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let payload = payload {
            request.httpBody = payload
        }

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            completionHandler(data, error)
        }.resume()
    }
}

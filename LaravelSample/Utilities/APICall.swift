//
//  APICall.swift
//  LaravelSample
//
//  Created by 管理者 on 2021/03/17.
//

import Foundation

enum APIError: Swift.Error {
    case unexpectedResponse
    case invalidURL
    case httpCode(HTTPCode)
}

protocol APICall {
    var path: String { get }
    var method: String { get }
    var headers: [String: String]? { get }
    func body() throws -> Data?
}


extension APICall {
    
    func urlRequest(baseURL: String) throws -> URLRequest {
        guard let url = URL(string: baseURL + path) else {
            throw APIError.invalidURL
        }
        
//        let str: NSString = "apple=apple_test&peach=peach_test" as NSString
//        let myData: NSData = str.data(using: String.Encoding.utf8.rawValue)! as NSData
        
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        request.httpBody = try body()
//        request.httpBody = myData as Data

        return request
    }
}

typealias HTTPCode = Int
typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
    static let success = 200 ..< 300
}

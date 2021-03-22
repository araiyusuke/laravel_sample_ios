//
//  APICall.swift
//  LaravelSample
//
//  Created by 管理者 on 2021/03/17.
//

import Foundation

/// APIエラー
enum APIError: Swift.Error {
    case unexpectedResponse
    case invalidURL
    case httpCode(HTTPCode)
}

protocol APICall {
    /// URLのパス
    var path: String { get }
    /// GET or POST
    var method: String { get }
    /// HTTP ヘッダー
    var headers: [String: String]? { get }
    /// POSTの中身
    func body() throws -> Data?
}

extension APICall {
    /// URLRequestを返す。
    /// - Parameter baseURL: <#baseURL description#>
    /// - Throws: <#description#>
    /// - Returns: <#description#>
    func urlRequest(baseURL: String) throws -> URLRequest {
        guard let url = URL(string: baseURL + path) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        request.httpBody = try body()
        return request
    }
}

typealias HTTPCode = Int
typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
    static let success = 200 ..< 300
}

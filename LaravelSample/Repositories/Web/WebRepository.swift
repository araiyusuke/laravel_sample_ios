//
//  WebRepository.swift
//  LaravelSample
//
//  Created by 管理者 on 2021/03/17.
//

import Foundation
import Combine

protocol WebRepository {
    var session: URLSession { get }
    var baseURL: String { get }
}

extension WebRepository {
    
    // singin
    func call<Value>(endpoint: APICall,httpCodes: HTTPCodes = .success, credential:Credential)
            -> AnyPublisher<Value, Error> where Value: Decodable {
        do {
            var request = try endpoint.urlRequest(baseURL: baseURL)
            let str: NSString = "email=\(credential.email)&password=\(credential.password)" as NSString
            request.httpBody = str.data(using: String.Encoding.utf8.rawValue)!
            return session.dataTaskPublisher(for: request).requestJSON(httpCodes:httpCodes)
        } catch let error {
            return Fail<Value, Error>(error: error).eraseToAnyPublisher()
        }
    }
    
    /// エンドポイントにアクセスしてリソースを取得する
    /// - Parameters:
    ///   - endpoint: <#endpoint description#>
    ///   - httpCodes: <#httpCodes description#>
    ///   - token: <#token description#>
    /// - Returns: <#description#>
    func call<Value>(endpoint: APICall,httpCodes: HTTPCodes = .success, token:Token)
            -> AnyPublisher<Value, Error> where Value: Decodable {
        
        do {
            var request = try endpoint.urlRequest(baseURL: baseURL)
            request.allHTTPHeaderFields = ["Authorization": "Bearer \(token.token)"]
            return session.dataTaskPublisher(for: request).requestJSON(httpCodes:httpCodes)
        } catch let error {
            return Fail<Value, Error>(error: error).eraseToAnyPublisher()
        }
    }
}

private extension Publisher where Output == URLSession.DataTaskPublisher.Output {
    
    func requestJSON<Value>(httpCodes: HTTPCodes) -> AnyPublisher<Value, Error> where Value: Decodable {
        return
            tryMap {
                guard let code = ($0.1 as? HTTPURLResponse)?.statusCode else {
                    throw APIError.unexpectedResponse
                }
            
                // レスポンスコードが200〜300以外なら、例外を発生させる。
                guard httpCodes.contains(code) else {
                    throw APIError.httpCode(code)
                }

                return $0.0
            }
            .decode(type: Value.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

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
    
    func call<Value>(endpoint: APICall,httpCodes: HTTPCodes = .success, credential:Credential)
            -> AnyPublisher<Value, Error> where Value: Decodable {
        do {
            
            var request = try endpoint.urlRequest(baseURL: baseURL)
            let str: NSString = "email=info.keisuke.arai@gmail.com&password=password" as NSString
            request.httpBody = str.data(using: String.Encoding.utf8.rawValue)!
            return session.dataTaskPublisher(for: request).requestJSON(httpCodes:httpCodes)
        } catch let error {
            return Fail<Value, Error>(error: error).eraseToAnyPublisher()
        }
    }
    
    func call<Value>(endpoint: APICall,httpCodes: HTTPCodes = .success, token:Token)
            -> AnyPublisher<Value, Error> where Value: Decodable {
        
        do {
            print("call")
//            let token = Token(token: "17|GkvJ8chkefDfC0N8rF5Nqe4VNBVjP23fNIBeOzqy")
            var request = try endpoint.urlRequest(baseURL: baseURL)
            request.allHTTPHeaderFields = ["Authorization": "Bearer \(token.token)"]
//            request.httpBody = str.data(using: String.Encoding.utf8.rawValue)!
            return session.dataTaskPublisher(for: request).requestJSON(httpCodes:httpCodes)
        } catch let error {
            return Fail<Value, Error>(error: error).eraseToAnyPublisher()
        }
    }
}

private extension Publisher where Output == URLSession.DataTaskPublisher.Output {
    
    func requestJSON<Value>(httpCodes: HTTPCodes) -> AnyPublisher<Value, Error> where Value: Decodable {


        // tryMap -> 例外が発生するかもしれないmap()関数
        // eraseToAnyPublisherしている。

        // try ~ catchしてErrorを次に渡す
        return tryMap {
            
                // $0.0 -> ステータスコード
                // $0.1 -> 取得した値
            
//            throw APIError.unexpectedResponse
                print("ノーエラー")
                guard let code = ($0.1 as? HTTPURLResponse)?.statusCode else {
                    throw APIError.unexpectedResponse
                }
            
                //httpCodes(200 ..< 300)の間にステータスコードが該当しない場合は、例外を発生させる。
                guard httpCodes.contains(code) else {
                    throw APIError.httpCode(code)
                }
//            print("\(code)")
//                print($0.1.debugDescription)
                // エラー出ないなら次へ
                print("ノーエラー")
                return $0.0
            }
            .decode(type: Value.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

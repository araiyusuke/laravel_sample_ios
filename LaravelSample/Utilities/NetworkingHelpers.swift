//
//  NetworkingHelpers.swift
//  LaravelSample
//
//  Created by 管理者 on 2021/03/20.
//

import Foundation
import Combine

extension Just where Output == Void {
    
    static func withErrorType<E>(_ errorType: E.Type) -> AnyPublisher<Void, E> {
        // ()はVoidを意味する。
        return withErrorType((), E.self)
        // ↓ withErrorTypeへ
    }
}

extension Just {
    
    // ( _ value: Output )
    // ( _ value: Void )
    // ( _ value: () )
    static func withErrorType<E>(_ value: Output, _ errorType: E.Type
    ) -> AnyPublisher<Output, E> {
        
        // このコードを省略して呼び出したいから拡張している。
        // Just<Void>.withErrorType(Error.self)
        return Just(value)
            //.setFailureType(to: Error.self)
            //指定したError Protocolに適合した型を出力するPublisherに変換します。
            //上記の例ですとJust<Int, Never>からJust<Int, Error>に変換しています
            .setFailureType(to: E.self) // sinkでエラーを取得する。
            .eraseToAnyPublisher()
    }
}

extension Publisher {
    
    /// sinkした結果をLoadableに変換する。
    /// Publisherを購読してエラーならLoadable.failed、それ以外はLoadable.loadedに更新してクロージャの引数に渡して返す。
    ///
    /// - Parameter completion: クロージャ
    /// - Returns: AnyCancellable
    func sinkToLoadable(_ completion: @escaping (Loadable<Output>) -> Void) -> AnyCancellable {
        return sink(receiveCompletion: { subscriptionCompletion in
            // Error -> Loadable.failed
            if let error = subscriptionCompletion.error {
                // クロージャの引数をセットする
                completion(.failed(error))
            }
        }, receiveValue: { value in
            // Loadable.loaded
            completion(.loaded(value))
        })
    }
    
    /// sinkして結果をResultベースに変換して返す。
    /// - Parameter result: クロージャ
    /// - Returns: AnyCancellable
    func sinkToResult(_ result: @escaping (Result<Output, Failure>) -> Void) -> AnyCancellable {
        return sink(receiveCompletion: { completion in
            
            // Error
            switch completion {
            case let .failure(error):
                result(.failure(error))
            default: break
            }
        }, receiveValue: { value in
            
            // Success
            result(.success(value))
        })
    }
}

extension Subscribers.Completion {
    var error: Failure? {
        switch self {
        case let .failure(error): return error
        default: return nil
        }
    }
}

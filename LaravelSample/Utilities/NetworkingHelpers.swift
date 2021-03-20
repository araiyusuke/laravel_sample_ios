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
    func sinkToLoadable(_ completion: @escaping (Loadable<Output>) -> Void) -> AnyCancellable {
        
        return sink(receiveCompletion: { subscriptionCompletion in

            // subscriptionCompletionには成功、失敗の結果が代入されている。
            
            // flatMapでエラーが発生した場合
            if let error = subscriptionCompletion.error {
                completion(.failed(error))
            }
                        
            
        }, receiveValue: { value in
            // 状態を.loadedに変更している。
            completion(.loaded(value))
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

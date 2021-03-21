//
//  AppEnvironment.swift
//  LaravelSample
//
//  Created by 管理者 on 2021/03/18.
//

import Foundation
import Combine

struct AppEnvironment {
    let container: DIContainer
}

extension AppEnvironment {
    
    // アプリ起動時に呼び出される。
    static func bootstrap() -> AppEnvironment {
        
        // インタラクタに渡すWebレポジトリを生成
        let session = configuredURLSession()
        let webRepositories = configuredWebRepositories(session: session)
        
        // インタラクタに渡すキーチェーンレポジトリを生成
        let keyChainRepositories = configuredKeyChainRepositories()
        
        let interactors = configuredInteractors(
            webRepositories: webRepositories,
            keyChainRepositories: keyChainRepositories
        )
        
        return AppEnvironment(container: .init(interactors: interactors))
    }
    
    // インタラクタを生成
    private static func configuredInteractors(
        webRepositories: DIContainer.WebRepositories,
        keyChainRepositories: DIContainer.KeyChainRepositories) -> DIContainer.Interactors {
        
        let authInteractor = RealAuthInteractor(
            webRepository: webRepositories.bearer,
            keyChainRepository: keyChainRepositories.bearer
        )
        return .init(authInteractor: authInteractor)
    }
    
    // 通信処理の設定
    private static func configuredURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }
    
    // キーチェーンの設定
//    private static func configuredKeyChainSetting() -> 
    
    // Webレポジトリを生成
    private static func configuredWebRepositories(session: URLSession) -> DIContainer.WebRepositories {
        let bearerTokenWebRepository = RealBearerTokenWebRepository(session: session, baseURL: "http://localhost:8081/api/")
        return .init(bearer: bearerTokenWebRepository)
    }
    
    // キーチェーンレポジトリを生成
    private static func configuredKeyChainRepositories() -> DIContainer.KeyChainRepositories {
        return .init(bearer: RealBearerTokenKeychainRepository(key: "key", service: "laravel"))
    }
    
}

extension DIContainer {
    struct WebRepositories {
        let bearer: BearerTokenWebRepository
    }
}

extension DIContainer {
    struct KeyChainRepositories {
        let bearer: RealBearerTokenKeychainRepository
    }
}

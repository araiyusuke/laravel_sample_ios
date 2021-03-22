//
//  AppEnvironment.swift
//  LaravelSample
//
//  Created by 管理者 on 2021/03/18.
//

import Foundation
import Combine

/// DIコンテナを管理する。
struct AppEnvironment {
    let container: DIContainer
}

extension AppEnvironment {
    
    ///   インタラクタを生成する。
    /// - Returns: <#description#>
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
        
        let userInteractor = RealUserInteractor(
            webRepository: webRepositories.user)
        
        return .init(authInteractor: authInteractor, userInteractor: userInteractor)
    }
    
    /// URLSessionを返す
    /// - Returns: URLSession
    private static func configuredURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }
    
    // キーチェーンの設定
//    private static func configuredKeyChainSetting() -> 
    
    // Webレポジトリを生成
    private static func configuredWebRepositories(session: URLSession) -> DIContainer.WebRepositories {
        
        let bearerTokenWebRepository = RealBearerTokenWebRepository(session: session, baseURL: "http://localhost:8081/api/")
        
        let userWebRepository = RealUserWebRepository(session: session, baseURL: "http://localhost:8081/api/")
        
        return .init(bearer: bearerTokenWebRepository, user: userWebRepository)
    }
    
    // キーチェーンレポジトリを生成
    private static func configuredKeyChainRepositories() -> DIContainer.KeyChainRepositories {
        return .init(bearer: RealBearerTokenKeychainRepository(key: "key", service: "laravel"))
    }
    
}

extension DIContainer {
    struct WebRepositories {
        let bearer: BearerTokenWebRepository
        let user: UserWebRepository
    }
}

extension DIContainer {
    struct KeyChainRepositories {
        let bearer: RealBearerTokenKeychainRepository
    }
}

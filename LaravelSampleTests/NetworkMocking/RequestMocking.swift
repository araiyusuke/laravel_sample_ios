//
//  RequestMocking.swift
//  LaravelSampleTests
//
//  Created by 管理者 on 2021/03/21.
//

import Foundation

extension URLSession {
    static var mockedResponsesOnly: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [RequestMocking.self, RequestBlocking.self]
        configuration.timeoutIntervalForRequest = 1
        configuration.timeoutIntervalForResource = 1
        return URLSession(configuration: configuration)
    }
}

/// MockedResponseインスタンスを管理するデータストア
extension RequestMocking {
        
    /// 通信結果の期待値を管理する配列
    static private var mocks: [MockedResponse] = []
    
    // 通信結果の期待値を追加する
    static func add(mock: MockedResponse) {
        mocks.append(mock)
    }
    
    /// 通信結果の期待値をすべて削除する
    static func removeAllMocks() {
        mocks.removeAll()
    }
    
    /// URLからモック用の期待値を返す
    /// - Parameter request: <#request description#>
    /// - Returns: 期待する
    static private func mock(for request: URLRequest) -> MockedResponse? {
        return mocks.first {
            $0.url == request.url
        }
    }
}

//Mock通信プロトコルを使うためURLProtocolを実装


/// iOS通信処理のインターフェースを使って通信処理をMock化する
final class RequestMocking: URLProtocol {

    // URLRequestと一致するモックデータが存在するなら有効にする。
    override class func canInit(with request: URLRequest) -> Bool {
        // mockが存在しないテストメソッドがある。
        return mock(for: request) != nil // trueなら処理を継続する。
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return false
    }

    override func startLoading() {
        
        // requestからmockデータを取得する。
        if let mock = RequestMocking.mock(for: request),
            let url = request.url,
            
            // mock.customResponseがnilでない -> customResponse
            // mock.customResponseがnil -> ①
            let response = mock.customResponse ??
                // ①
                HTTPURLResponse(url: url,
                statusCode: mock.httpCode,
                httpVersion: "HTTP/1.1",
                headerFields: mock.headers) {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + mock.loadingTime) { [weak self] in
                
                guard let self = self else { return }
                
                // didReceive
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                
                switch mock.result {
                
                case let .success(data):
                    // didLoad
                    self.client?.urlProtocol(self, didLoad: data)
                    self.client?.urlProtocolDidFinishLoading(self)
                    
                case let .failure(error):
                    let failure = NSError(domain: NSURLErrorDomain, code: 1,
                                          userInfo: [NSUnderlyingErrorKey: error])
                    self.client?.urlProtocol(self, didFailWithError: failure)
                }
            }
        }
    }

    override func stopLoading() { }
}

// MARK: - RequestBlocking

private class RequestBlocking: URLProtocol {
    
    enum Error: Swift.Error {
        case requestBlocked
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        DispatchQueue(label: "").async {
            self.client?.urlProtocol(self, didFailWithError: Error.requestBlocked)
        }
    }
    override func stopLoading() { }
}

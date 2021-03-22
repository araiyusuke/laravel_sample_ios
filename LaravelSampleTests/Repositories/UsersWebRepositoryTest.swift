//
//  UsersWebRepository.swift
//  LaravelSampleTests
//
//  Created by 管理者 on 2021/03/21.
//

import XCTest
import Combine
@testable import LaravelSample

class UsersWebRepository: XCTestCase {

  
    private var subscriptions = Set<AnyCancellable>()

    private var sut: RealUserWebRepository!

    override func setUpWithError() throws {
        sut = RealUserWebRepository(session: .mockedResponsesOnly, baseURL: "http://test.com")
        subscriptions = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        RequestMocking.removeAllMocks()
    }

    func test_ユーザー情報を取得() throws {
        
        let expected = User.mockedData[0]
        let mockedToken = Token.mockedData[0]
        let exp = XCTestExpectation(description: "Completion")

        // http://test.com/showにアクセス
        try mock(API.show, result: .success(expected))
        
        sut.load(token: mockedToken).sinkToResult { result in
            result.assertSuccess(value: expected)
            exp.fulfill()
        }.store(in: &subscriptions)
        
        // 非同期の処理をテストするために必要。これがないと次のテストに移行してしまう。
        wait(for: [exp], timeout: 2)
    }
    
    typealias API = RealUserWebRepository.API
    typealias Mock = RequestMocking.MockedResponse


    /// MockedResponseをインスタンス化、RequestMockingに追加する
    /// - Parameters:
    ///   - apiCall: 呼び出したいAPI
    ///   - result: 期待する通信結果
    ///   - httpCode: 期待するレスポンスステータスコード
    /// - Throws: <#description#>
    private func mock<T>(_ apiCall: API, result: Result<T, Swift.Error>,
                         httpCode: HTTPCode = 200) throws where T: Encodable {
        let mock = try Mock(apiCall: apiCall, baseURL: sut.baseURL, result: result, httpCode: httpCode)
        RequestMocking.add(mock: mock)
    }
}

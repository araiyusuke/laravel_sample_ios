//
//  TestHelper.swift
//  LaravelSampleTests
//
//  Created by 管理者 on 2021/03/21.
//

import Foundation
import XCTest
import SwiftUI
import Combine
@testable import LaravelSample

extension Result where Success: Equatable {
    
    /// モックで指定した期待値通りになっているか検証するためのアサーション
    /// - Parameters:
    ///   - value: <#value description#>
    ///   - file: <#file description#>
    ///   - line: <#line description#>
    func assertSuccess(value: Success, file: StaticString = #file, line: UInt = #line) {
        switch self {
        case let .success(resultValue):
            XCTAssertEqual(resultValue, value, file: file, line: line)
        case let .failure(error):
            XCTFail("Unexpected error: \(error)", file: file, line: line)
        }
    }
}

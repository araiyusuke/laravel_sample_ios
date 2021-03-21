//
//  Loadable.swift
//  LaravelSample
//
//  Created by 管理者 on 2021/03/17.
//

import Foundation
import SwiftUI

enum Loadable<T> {
    case notRequested
    case isLoading
    case loaded(T)
    case failed(Error)
}

extension Loadable {
    mutating func setIsLoading() {
        self = .isLoading
    }
}

typealias LoadableSubject<Value> = Binding<Loadable<Value>>

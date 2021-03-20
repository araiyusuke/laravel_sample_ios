//
//  Models.swift
//  LaravelSample
//
//  Created by 管理者 on 2021/03/18.
//

import Foundation

struct Token: Codable, Equatable {
    let token: String
}

struct Country: Codable, Equatable {
    
    let name: String
    let translations: [String: String?]
    let population: Int
    let flag: URL?
    let alpha3Code: Code
    
    typealias Code = String
}

extension Country {
    struct Details: Codable, Equatable {
        let capital: String
        let currencies: [Currency]
        let neighbors: [Country]
    }
}

extension Country.Details {
    struct Intermediate: Codable, Equatable {
        let capital: String
        let currencies: [Country.Currency]
        let borders: [String]
    }
}

extension Country {
    struct Currency: Codable, Equatable {
        let code: String
        let symbol: String?
        let name: String
    }
}

// MARK: - Helpers

extension Country: Identifiable {
    var id: String { alpha3Code }
}

extension Country.Currency: Identifiable {
    var id: String { code }
}

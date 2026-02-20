//
//  tokens_response_model.swift
//  GenStore
//
//  Created by Krishna Bhattacharya on 29/12/25.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let tokenResponseModel = try? JSONDecoder().decode(TokenResponseModel.self, from: jsonData)

import Foundation

// MARK: - TokenResponseModel
struct TokenResponseModel: Codable {
    let success: Bool?
    let message: String?
    let tokens: Tokens?
}



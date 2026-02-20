//
//  register_response_model.swift
//  10Store
//
//  Created by Krishna Bhattacharya on 05/12/25.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let registerResponseModel = try? JSONDecoder().decode(RegisterResponseModel.self, from: jsonData)

import Foundation

// MARK: - RegisterResponseModel
struct RegisterResponseModel: Codable {
    let success: Bool?
    let message: String?
    let user: User?
    let tokens: Tokens?
}

// MARK: - Tokens
struct Tokens: Codable {
    let accessToken, refreshToken: String?
}

// MARK: - User
struct User: Codable {
    let name, mobileNumber, address, nearByLocation: String?
    let city: String?
    let walletAmount: Int?
    let referralCode: String?
    let pincode: Int?
    let isActive: Bool?
    let id, createdAt, updatedAt, lastLogin: String?

    enum CodingKeys: String, CodingKey {
        case name, mobileNumber, address, nearByLocation, city, walletAmount, referralCode, pincode, isActive
        case id = "_id"
        case createdAt, updatedAt, lastLogin
    }
}

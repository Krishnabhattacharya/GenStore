//
//  login_response_model.swift
//  GenStore
//
//  Created by Krishna Bhattacharya on 08/12/25.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let loginResponseModel = try? JSONDecoder().decode(LoginResponseModel.self, from: jsonData)

import Foundation

// MARK: - LoginResponseModel
struct LoginResponseModel: Codable {
    let success: Bool?
    let message: String?
    let user: User?
    let tokens: Tokens?
}

// MARK: - Tokens
//struct Tokens: Codable {
//    let accessToken, refreshToken: String?
//}
//
//// MARK: - User
//struct User: Codable {
//    let id, name, mobileNumber, address: String?
//    let nearByLocation, city: String?
//    let walletAmount: Int?
//    let referralCode: String?
//    let pincode: Int?
//    let isActive: Bool?
//    let createdAt, updatedAt, lastLogin: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id = "_id"
//        case name, mobileNumber, address, nearByLocation, city, walletAmount, referralCode, pincode, isActive, createdAt, updatedAt, lastLogin
 //   }
//}

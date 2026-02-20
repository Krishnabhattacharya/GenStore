//
//  cart_res_model.swift
//  GenStore
//
//  Created by Krishna Bhattacharya on 29/12/25.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let cartResponseModel = try? JSONDecoder().decode(CartResponseModel.self, from: jsonData)

import Foundation

// MARK: - CartResponseModel
struct CartResponseModel: Codable {
    let success: Bool?
    let message: String?
    let cart: [Cart]?
}

// MARK: - Cart
struct Cart: Codable {
    let userID, productID: String?
    let quantity: Int?
    let size, color: String?
    let price: Int?
    let image: String?
    let title, shortDiscription, id, createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case productID = "productId"
        case quantity, size, color, price, image, title, shortDiscription
        case id = "_id"
        case createdAt, updatedAt
    }
}

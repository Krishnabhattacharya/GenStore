//
//  order_res_model.swift
//  GenStore
//
//  Created by Krishna Bhattacharya on 30/12/25.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let orderPlaceResponseModel = try? JSONDecoder().decode(OrderPlaceResponseModel.self, from: jsonData)

import Foundation

// MARK: - OrderPlaceResponseModel
struct OrderPlaceResponseModel: Codable {
    let order: Order?
    let success: Bool?
}

// MARK: - Order
struct Order: Codable,Hashable,Identifiable {
    let userID, productID: String?
    let quantity: Int?
    let size, color: String?
    let price: Int?
    let image, title, shortDiscription: String?
    let isPacked, isCallDone, isPaymentDone, isDelivered: Bool?
    let deliveryMethod, id, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case productID = "productId"
        case quantity, size, color, price, image, title, shortDiscription, isPacked, isCallDone, isPaymentDone, isDelivered, deliveryMethod
        case id = "_id"
        case createdAt, updatedAt
    }
}

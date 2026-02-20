//
//  order_req_model.swift
//  GenStore
//
//  Created by Krishna Bhattacharya on 30/12/25.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let orderPlaceRequestModel = try? JSONDecoder().decode(OrderPlaceRequestModel.self, from: jsonData)

import Foundation

// MARK: - OrderPlaceRequestModel
struct OrderPlaceRequestModel: Codable {
    let userID, productID: String?
    let quantity: Int?
    let size, color: String?
    let price: Int?
    let image, title, shortDiscription: String?
    let isPacked, isCallDone, isPaymentDone, isDelivered: Bool?
    let deliveryMethod: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case productID = "productId"
        case quantity, size, color, price, image, title, shortDiscription, isPacked, isCallDone, isPaymentDone, isDelivered, deliveryMethod
    }
}

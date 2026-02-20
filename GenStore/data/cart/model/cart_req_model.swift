//
//  cart_req_model.swift
//  GenStore
//
//  Created by Krishna Bhattacharya on 29/12/25.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let cartRequestModel = try? JSONDecoder().decode(CartRequestModel.self, from: jsonData)

import Foundation

// MARK: - CartRequestModel
struct CartRequestModel: Codable {
    let productID: String?
    let quantity: Int?
    let size, color: String?
    let price: Int?
    let image: String?
    let title, shortDiscription: String?

    enum CodingKeys: String, CodingKey {
        case productID = "productId"
        case quantity, size, color, price, image, title, shortDiscription
    }
}

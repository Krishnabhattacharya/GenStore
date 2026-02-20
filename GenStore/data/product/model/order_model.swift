//
//  order_model.swift
//  GenStore
//
//  Created by Krishna Bhattacharya on 05/01/26.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let allOrderResponseModel = try? JSONDecoder().decode(AllOrderResponseModel.self, from: jsonData)

import Foundation

// MARK: - AllOrderResponseModel
struct AllOrderResponseModel: Codable {
    let success: Bool?
    let orders: [Order]?
    let totalPages, currentPage, totalOrders: Int?
}




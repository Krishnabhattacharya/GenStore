//
//  product_model.swift
//  GenStore
//
//  Created by Krishna Bhattacharya on 08/12/25.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let productResponseModel = try? JSONDecoder().decode(ProductResponseModel.self, from: jsonData)

import Foundation

// MARK: - ProductResponseModel
struct ProductResponseModel: Codable {
    let success: Bool?
    let products: [Product]?
    let totalPages, currentPage, totalProducts: Int?
}

// MARK: - Product
struct Product: Codable {
    let id, title, category, subCategory: String?
    let assets: [Asset]?
    let colors: [String]?
    let sizes: [Size]?
    let price: Double?
    let description, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title, category, subCategory, assets, colors, sizes, price, description, createdAt, updatedAt
    }
}

// MARK: - Asset
struct Asset: Codable {
    let type: String?
    let url: String?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case type, url
        case id = "_id"
    }
}

// MARK: - Size
struct Size: Codable {
    let sizeName, weightRange, id: String?

    enum CodingKeys: String, CodingKey {
        case sizeName, weightRange
        case id = "_id"
    }
}

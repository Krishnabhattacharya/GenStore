//
//  register_request_model.swift
//  10Store
//
//  Created by Krishna Bhattacharya on 05/12/25.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let registerRequestModel = try? JSONDecoder().decode(RegisterRequestModel.self, from: jsonData)

import Foundation

// MARK: - RegisterRequestModel
struct RegisterRequestModel: Codable {
    let mobileNumber, name, password, city: String?
    let pincode: Int?
    let address, nearByLocation: String?
}

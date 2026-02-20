//
//  product_repo.swift
//  GenStore
//
//  Created by Krishna Bhattacharya on 08/12/25.
//

protocol ProductRepo{
    func getProduct(type :String)async throws -> ProductResponseModel
    func getOrders()async throws -> AllOrderResponseModel

}

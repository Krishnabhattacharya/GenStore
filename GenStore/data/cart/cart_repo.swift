//
//  cart_repo.swift
//  GenStore
//
//  Created by Krishna Bhattacharya on 29/12/25.
//

protocol CartRepo{
    func addToCart(req :CartRequestModel)async throws -> CartResponseModel
    func getUserCart()async throws -> CartResponseModel
    func addToOrder(req :OrderPlaceRequestModel)async throws -> OrderPlaceResponseModel
    func deleteCart(id:String)async throws

}

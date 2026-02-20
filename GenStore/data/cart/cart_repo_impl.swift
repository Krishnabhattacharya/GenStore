//
//  cart_repo_impl.swift
//  GenStore
//
//  Created by Krishna Bhattacharya on 29/12/25.
//

class CartRepoImpl: CartRepo {
    private let apiClient:Apiclient
    init (apiClient:Apiclient) {
        self.apiClient = apiClient
    }
    func addToCart(req : CartRequestModel) async throws -> CartResponseModel {
            return try await apiClient.post(_path: cartEndPoint, _body: req)
        }
    
    func getUserCart() async throws -> CartResponseModel {
        return try await apiClient.get(getCartEndPoint)
        }
    func addToOrder(req : OrderPlaceRequestModel) async throws -> OrderPlaceResponseModel {
            return try await apiClient.post(_path:placeOrderEndPoint, _body: req)
        }
    func deleteCart(id:String) async throws {
        try await apiClient.delete(deleteCartitem + id)
    }

}

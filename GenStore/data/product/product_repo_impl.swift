//
//  product_repo_impl.swift
//  GenStore
//
//  Created by Krishna Bhattacharya on 08/12/25.
//

class ProductRepoImpl: ProductRepo {
    private let apiClient:Apiclient
    init (apiClient:Apiclient) {
        self.apiClient = apiClient
    }
    func getProduct(type: String) async throws -> ProductResponseModel {
            let endpoint = productsEndPoint + type
            return try await apiClient.get(endpoint)
        }
    func getOrders() async throws -> AllOrderResponseModel {
            return try await apiClient.get(getOrdersEndPoint)
        }
}

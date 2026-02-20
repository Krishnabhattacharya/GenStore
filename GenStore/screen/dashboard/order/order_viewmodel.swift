//
//  order_viewmodel.swift
//  GenStore
//
//  Created by Krishna Bhattacharya on 05/01/26.
//

import SwiftUI

@MainActor
class OrderViewModel: ObservableObject {
    
    private let productRepo: ProductRepo
    
    init(productRepo: ProductRepo = ProductRepoImpl(apiClient: Apiclient.shared)) {
        self.productRepo = productRepo
    }
    
    @Published var state: ViewState = .idle
    @Published var orderItems: [Order] = []
    
    func getCartItems() async {
        state = .loading
        
        do {
            let res = try await productRepo.getOrders()
            orderItems = res.orders ?? []
            state = orderItems.isEmpty ? .empty : .success
        } catch {
            state = .error(
                error.localizedDescription.isEmpty
                ? "Server Error"
                : error.localizedDescription
            )
        }
    }
}

//
//  cart_viewmodel.swift
//  GenStore
//
//  Created by Krishna Bhattacharya on 30/12/25.
//
import SwiftUI

@MainActor
class CartViewModel: ObservableObject {

    private let cartrepo: CartRepo

    init(cartrepo: CartRepo = CartRepoImpl(apiClient: Apiclient.shared)) {
        self.cartrepo = cartrepo
    }

    @Published var state: ViewState = .idle
    @Published var cartItems: [Cart] = []

    func getCartItems() async {
        state = .loading

        do {
            let res = try await cartrepo.getUserCart()
            cartItems = res.cart ?? []
            state = cartItems.isEmpty ? .empty : .success
        } catch {
            state = .error(
                error.localizedDescription.isEmpty
                ? "Server Error"
                : error.localizedDescription
            )
        }
    }
    
    
    func placeOrdersFromCart() async {
        state = .loading

        do {
            for cart in cartItems {
                let req = OrderPlaceRequestModel(
                    userID: StorageServices.shared.getUser()?.user?.id,
                    productID: cart.productID,
                    quantity: cart.quantity,
                    size: cart.size,
                    color: cart.color,
                    price: cart.price,
                    image: cart.image,
                    title: cart.title,
                    shortDiscription: cart.shortDiscription,
                    isPacked: false,
                    isCallDone: false,
                    isPaymentDone: false,
                    isDelivered: false,
                    deliveryMethod: "delivery"
                );
                
                _ =  try await cartrepo.addToOrder(req: req)
                try await cartrepo.deleteCart(id: cart.id!)
            }
            cartItems.removeAll()
            state = .empty

        } catch {
            state = .error(
                error.localizedDescription.isEmpty
                ? "Server Error"
                : error.localizedDescription
            )
        }
    }
    func removeFromCart(at index: Int) {
            guard index < cartItems.count else { return }

            let removedItem = cartItems[index]
            cartItems.remove(at: index)
            state = cartItems.isEmpty ? .empty : .success
            Task {
                do {
                    try await cartrepo.deleteCart(id:removedItem.id!)
                    
                } catch {
                    await getCartItems()
                }
            }
        }
    }

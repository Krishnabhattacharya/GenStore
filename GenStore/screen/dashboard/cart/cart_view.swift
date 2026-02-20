//
//  cart_view.swift
//  GenStore
//
//  Created by Krishna Bhattacharya on 30/12/25.
//
import SwiftUI

struct CartView: View {
    @EnvironmentObject var router: Router
    @State private var showCheckoutAlert = false
    @EnvironmentObject var vm: CartViewModel

    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    router.pop()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Back")
                    }
                    .foregroundColor(.blue)
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 4)
                        ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("My Cart")
                        .font(.largeTitle)
                        .bold()
                        .padding(.horizontal)

                    switch vm.state {
                    case .idle, .loading:
                        HStack {
                            Spacer()
                            ProgressView("Loading...")
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, minHeight: 300)

                    case .success:
                        if vm.cartItems.isEmpty {
                            emptyCartView
                        } else {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(vm.cartItems.indices, id: \.self) { i in
                                    CartBox(
                                        cart: vm.cartItems[i],
                                        onRemove: {
                                            vm.removeFromCart(at: i)
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                    case .empty:
                        emptyCartView

                    case .error(let string):
                        VStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 48))
                                .foregroundColor(.red)
                            Text(string)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity, minHeight: 300)
                        .padding()
                    }
                }
                .padding(.bottom, 120)
            }
            
            if case .success = vm.state, !vm.cartItems.isEmpty {
                bottomCheckoutBar
            }
        }
        .navigationBarBackButtonHidden(true)
        .task {
            await vm.getCartItems()
        }
        .alert("Place Order", isPresented: $showCheckoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Confirm Order") {
                placeOrder()
            }
        } message: {
            Text("Are you sure you want to place this order for $\(String(format: "%.2f", totalPrice))?")
        }
    }
        private var emptyCartView: some View {
        VStack(spacing: 20) {
            Image(systemName: "cart.badge.minus")
                .font(.system(size: 80))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("Your cart is empty")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            
            Text("Add items to get started")
                .font(.body)
                .foregroundColor(.gray.opacity(0.7))
            
            Button(action: {
                router.pop()
            }) {
                Text("Continue Shopping")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, minHeight: 300)
        .padding()
    }
    
    private var bottomCheckoutBar: some View {
        VStack(spacing: 0) {
            Divider()
            
            VStack(spacing: 12) {
                HStack {
                    Text("Items (\(vm.cartItems.count))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    Text("$\(String(format: "%.2f", subtotal))")
                        .font(.subheadline)
                }
                                HStack {
                    Text("Shipping")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    Text(shippingCost > 0 ? "$\(String(format: "%.2f", shippingCost))" : "FREE")
                        .font(.subheadline)
                        .foregroundColor(shippingCost > 0 ? .primary : .green)
                }
                
                Divider()
                    .padding(.vertical, 4)
                                HStack {
                    Text("Total")
                        .font(.title3)
                        .fontWeight(.bold)
                    Spacer()
                    Text("$\(String(format: "%.2f", totalPrice))")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                
                Button(action: {
                    showCheckoutAlert = true
                }) {
                    HStack {
                        Image(systemName: "cart.fill")
                        Text("Place Order")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding(.top, 4)
            }
            .padding()
            .background(Color.white)
        }
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
    }
    
    private var subtotal: Double {
        vm.cartItems.reduce(0) { $0 + Double($1.price ?? 0) }
    }
    
    private var shippingCost: Double {
        subtotal > 50 ? 0 : 5.99
    }
    
    private var totalPrice: Double {
        subtotal + shippingCost
    }
    
    private func placeOrder() {
        router.navigate(to: .address)
    }
}

struct CartBox: View {
    var cart: Cart
    var onRemove: () -> Void
    
    @State private var showRemoveAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: cart.image ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 120)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                                Button(action: {
                    showRemoveAlert = true
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.red)
                        .background(Circle().fill(Color.white))
                }
                .padding(8)
            }

            Text(cart.title ?? "")
                .font(.headline)
                .lineLimit(2)
                .frame(height: 40, alignment: .top)

            HStack {
                Text("$\(cart.price ?? 0)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                Spacer()
                
                // Quantity badge (if you have quantity in your model)
                // Text("Qty: 1")
                //     .font(.caption)
                //     .padding(.horizontal, 8)
                //     .padding(.vertical, 4)
                //     .background(Color.gray.opacity(0.2))
                //     .cornerRadius(8)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 4)
        )
        .alert("Remove Item", isPresented: $showRemoveAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Remove", role: .destructive) {
                onRemove()
            }
        } message: {
            Text("Are you sure you want to remove this item from your cart?")
        }
    }
}

//
//  OrdersListScreen.swift
//  GenStore
//
//  Created by Krishna Bhattacharya on 05/01/26.
//



// MARK: - Orders List Screen
//
//  OrdersListScreen.swift
//  GenStore
//
//  Created by Krishna Bhattacharya on 05/01/26.
//

import SwiftUI

// MARK: - Orders List Screen
struct OrdersListScreen: View {
    @EnvironmentObject var viewModel: OrderViewModel
    @EnvironmentObject var router: Router
    @State private var selectedFilter: OrderFilter = .all
    
    var filteredOrders: [Order] {
        switch selectedFilter {
        case .all:
            return viewModel.orderItems
        case .pending:
            return viewModel.orderItems.filter { $0.isDelivered != true }
        case .delivered:
            return viewModel.orderItems.filter { $0.isDelivered == true }
        }
    }
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            switch viewModel.state {
            case .idle:
                Color.clear
                    .onAppear {
                        Task {
                            await viewModel.getCartItems()
                        }
                    }
                
            case .loading:
                LoadingView()
                
            case .success:
                ScrollView {
                    VStack(spacing: 16) {
                        // Filter Chips
                        FilterChipsView(selectedFilter: $selectedFilter)
                            .padding(.horizontal)
                            .padding(.top, 8)
                        
                        // Orders List
                        if filteredOrders.isEmpty {
                            EmptyFilterView(filter: selectedFilter)
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(filteredOrders) { order in
                                    Button {
                                        // Navigate to order detail
                                        router.navigate(to: .orderDetails(order))
                                    } label: {
                                        OrderCardView(order: order)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 16)
                }
                .refreshable {
                    await viewModel.getCartItems()
                }
                
            case .empty:
                EmptyOrdersView()
                
            case .error(let message):
                ErrorView(message: message) {
                    Task {
                        await viewModel.getCartItems()
                    }
                }
            }
        }
        .navigationTitle("My Orders")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Order Filter
enum OrderFilter: String, CaseIterable {
    case all = "All"
    case pending = "Pending"
    case delivered = "Delivered"
}

// MARK: - Filter Chips View
struct FilterChipsView: View {
    @Binding var selectedFilter: OrderFilter
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(OrderFilter.allCases, id: \.self) { filter in
                    FilterChip(
                        title: filter.rawValue,
                        isSelected: selectedFilter == filter
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            selectedFilter = filter
                        }
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Filter Chip
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.blue : Color(.systemGray6))
                )
        }
    }
}

// MARK: - Order Card View
struct OrderCardView: View {
    let order: Order
    
    var orderStatus: String {
        if order.isDelivered == true {
            return "Delivered"
        } else if order.isPacked == true {
            return "Packed"
        } else if order.isCallDone == true {
            return "Confirmed"
        } else {
            return "Order Placed"
        }
    }
    
    var statusColor: Color {
        if order.isDelivered == true {
            return .green
        } else if order.isPacked == true {
            return .orange
        } else {
            return .blue
        }
    }
    
    var statusIcon: String {
        if order.isDelivered == true {
            return "checkmark.seal.fill"
        } else if order.isPacked == true {
            return "shippingbox.fill"
        } else if order.isCallDone == true {
            return "phone.fill"
        } else {
            return "cart.fill"
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                // Product Image
                AsyncImage(url: URL(string: order.image ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        )
                }
                .frame(width: 80, height: 80)
                .cornerRadius(12)
                
                // Product Details
                VStack(alignment: .leading, spacing: 6) {
                    Text(order.title ?? "Product")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 8) {
                        if let size = order.size {
                            Text("Size: \(size)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        if let color = order.color {
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(colorFromString(color))
                                    .frame(width: 10, height: 10)
                                Text(color)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    if let quantity = order.quantity {
                        Text("Qty: \(quantity)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    HStack {
                        if let price = order.price {
                            Text("₹\(price)")
                                .font(.headline)
                                .foregroundColor(.green)
                        }
                        
                        Spacer()
                        
                        // Status Badge
                        HStack(spacing: 4) {
                            Image(systemName: statusIcon)
                                .font(.caption2)
                            Text(orderStatus)
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(statusColor)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(statusColor.opacity(0.15))
                        )
                    }
                }
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            
            // Order Info Footer
            Divider()
            
            HStack {
                Label(
                    "Order ID: \(order.id?.suffix(8).uppercased() ?? "N/A")",
                    systemImage: "number"
                )
                .font(.caption2)
                .foregroundColor(.secondary)
                
                Spacer()
                
                if let date = order.createdAt {
                    Text(formatDate(date))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(.systemGray6).opacity(0.5))
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
    }
    
    private func colorFromString(_ colorName: String) -> Color {
        switch colorName.lowercased() {
        case "red": return .red
        case "blue": return .blue
        case "green": return .green
        case "yellow": return .yellow
        case "orange": return .orange
        case "purple": return .purple
        case "pink": return .pink
        case "black": return .black
        case "white": return .white
        case "gray", "grey": return .gray
        default: return .gray
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        if let date = isoFormatter.date(from: dateString) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy"
            return formatter.string(from: date)
        }
        return ""
    }
}

// MARK: - Loading View
struct LoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading orders...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Empty Orders View
struct EmptyOrdersView: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "bag.fill")
                .font(.system(size: 80))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("No Orders Yet")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Start shopping and your orders\nwill appear here")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: {
                router.navigate(to: .home)
            }) {
                Text("Start Shopping")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.top, 8)
        }
        .padding()
    }
}

// MARK: - Empty Filter View
struct EmptyFilterView: View {
    let filter: OrderFilter
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "tray.fill")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("No \(filter.rawValue) Orders")
                .font(.headline)
            
            Text("You don't have any \(filter.rawValue.lowercased()) orders")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .padding(.top, 60)
    }
}

// MARK: - Error View
struct ErrorView: View {
    let message: String
    let retry: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundColor(.red.opacity(0.7))
            
            Text("Oops!")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: retry) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Try Again")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 14)
                .background(Color.blue)
                .cornerRadius(12)
            }
        }
        .padding()
    }
}

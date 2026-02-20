//
//  order_screen.swift
//  GenStore
//
//  Created by Krishna Bhattacharya on 05/01/26.
//

//
//  OrderDetailScreen.swift
//  GenStore
//
//  Created by Krishna Bhattacharya on 06/01/26.
//
//
//  OrderDetailScreen.swift
//  GenStore
//
//  Created by Krishna Bhattacharya on 06/01/26.
//

import SwiftUI

struct OrderDetailScreen: View {
    @EnvironmentObject var router: Router
    let order: Order
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Product Image Section
                ProductImageSection(imageURL: order.image)
                
                VStack(spacing: 24) {
                    // Product Info
                    ProductInfoSection(order: order)
                    
                    Divider()
                    
                    // Order Status Timeline
                    OrderStatusTimeline(order: order)
                    
                    Divider()
                    
                    // Product Description
                    if let description = order.shortDiscription, !description.isEmpty && description != "No Des" {
                        ProductDescriptionSection(description: description)
                        Divider()
                    }
                    
                    // Price Breakdown
                    PriceBreakdownSection(order: order)
                    
                    Divider()
                    
                    // Order Details
                    OrderDetailsSection(order: order)
                    
                    Divider()
                    
                    // Delivery Method
                    DeliveryMethodSection(order: order)
                }
                .padding()
            }
        }
        .navigationTitle("Order Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: {
                        // Copy order ID
                    }) {
                        Label("Copy Order ID", systemImage: "doc.on.doc")
                    }
                    
                    Button(action: {
                        // Contact support
                    }) {
                        Label("Contact Support", systemImage: "message")
                    }
                    
                    Button(role: .destructive, action: {
                        // Cancel order
                    }) {
                        Label("Cancel Order", systemImage: "xmark.circle")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
    }
}

// MARK: - Product Image Section
struct ProductImageSection: View {
    let imageURL: String?
    
    var body: some View {
        AsyncImage(url: URL(string: imageURL ?? "")) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .overlay(
                    ProgressView()
                )
        }
        .frame(maxWidth: .infinity)
        .frame(height: 300)
        .background(Color(.systemGray6))
    }
}

// MARK: - Product Info Section
struct ProductInfoSection: View {
    let order: Order
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(order.title ?? "Product")
                .font(.title2)
                .fontWeight(.bold)
            
            HStack(spacing: 16) {
                if let size = order.size {
                    InfoPill(icon: "ruler", text: "Size: \(size)")
                }
                
                if let color = order.color {
                    InfoPill(icon: "paintpalette", text: color, color: colorFromString(color))
                }
                
                if let quantity = order.quantity {
                    InfoPill(icon: "number", text: "Qty: \(quantity)")
                }
            }
            
            if let price = order.price {
                Text("₹\(price)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
}

// MARK: - Info Pill
struct InfoPill: View {
    let icon: String
    let text: String
    var color: Color?
    
    var body: some View {
        HStack(spacing: 6) {
            if let color = color {
                Circle()
                    .fill(color)
                    .frame(width: 12, height: 12)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 1)
                    )
            } else {
                Image(systemName: icon)
                    .font(.caption)
            }
            Text(text)
                .font(.subheadline)
        }
        .foregroundColor(.secondary)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

// MARK: - Order Status Timeline
struct OrderStatusTimeline: View {
    let order: Order
    
    var orderStages: [(title: String, subtitle: String, isCompleted: Bool, icon: String)] {
        [
            ("Order Placed", "Your order has been placed", true, "cart.fill"),
            ("Confirmed", "Order confirmed by seller", order.isCallDone == true, "phone.fill"),
            ("Packed", "Your order is being packed", order.isPacked == true, "shippingbox.fill"),
            ("Delivered", "Order delivered successfully", order.isDelivered == true, "checkmark.seal.fill")
        ]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Order Status")
                .font(.headline)
            
            VStack(spacing: 0) {
                ForEach(Array(orderStages.enumerated()), id: \.offset) { index, stage in
                    HStack(alignment: .top, spacing: 12) {
                        // Timeline indicator
                        VStack(spacing: 0) {
                            ZStack {
                                Circle()
                                    .fill(stage.isCompleted ? Color.green : Color(.systemGray5))
                                    .frame(width: 32, height: 32)
                                
                                Image(systemName: stage.icon)
                                    .font(.caption)
                                    .foregroundColor(stage.isCompleted ? .white : .gray)
                            }
                            
                            if index < orderStages.count - 1 {
                                Rectangle()
                                    .fill(orderStages[index + 1].isCompleted ? Color.green : Color(.systemGray5))
                                    .frame(width: 2, height: 40)
                            }
                        }
                        
                        // Stage info
                        VStack(alignment: .leading, spacing: 4) {
                            Text(stage.title)
                                .font(.subheadline)
                                .fontWeight(stage.isCompleted ? .semibold : .regular)
                                .foregroundColor(stage.isCompleted ? .primary : .secondary)
                            
                            Text(stage.subtitle)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 4)
                        
                        Spacer()
                    }
                }
            }
        }
    }
}

// MARK: - Product Description Section
struct ProductDescriptionSection: View {
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "doc.text.fill")
                    .foregroundColor(.blue)
                Text("Description")
                    .font(.headline)
            }
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineSpacing(4)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6).opacity(0.5))
                .cornerRadius(12)
        }
    }
}

// MARK: - Price Breakdown Section
struct PriceBreakdownSection: View {
    let order: Order
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Price Details")
                .font(.headline)
            
            VStack(spacing: 12) {
                PriceRow(title: "Price per item", value: order.price ?? 0)
                PriceRow(title: "Quantity", value: order.quantity ?? 1, isQuantity: true)
                
                Divider()
                
                if let price = order.price, let quantity = order.quantity {
                    HStack {
                        Text("Total Amount")
                            .font(.headline)
                        Spacer()
                        Text("₹\(price * quantity)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6).opacity(0.3))
            .cornerRadius(12)
        }
    }
}

// MARK: - Price Row
struct PriceRow: View {
    let title: String
    let value: Int
    var isQuantity: Bool = false
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            if isQuantity {
                Text("\(value)")
                    .font(.subheadline)
                    .fontWeight(.medium)
            } else {
                Text("₹\(value)")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
        }
    }
}

// MARK: - Order Details Section
struct OrderDetailsSection: View {
    let order: Order
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Order Information")
                .font(.headline)
            
            VStack(spacing: 12) {
                DetailRow(
                    title: "Order ID",
                    value: order.id?.suffix(12).uppercased() ?? "N/A",
                    icon: "number"
                )
                
                if let date = order.createdAt {
                    DetailRow(
                        title: "Order Date",
                        value: formatDate(date),
                        icon: "calendar"
                    )
                }
                
                DetailRow(
                    title: "Payment Method",
                    value: order.isPaymentDone == true ? "Paid" : "Cash on Delivery",
                    icon: "creditcard"
                )
            }
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        if let date = isoFormatter.date(from: dateString) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy, hh:mm a"
            return formatter.string(from: date)
        }
        return dateString
    }
}

// MARK: - Delivery Method Section
struct DeliveryMethodSection: View {
    let order: Order
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "shippingbox.fill")
                    .foregroundColor(.orange)
                Text("Delivery Method")
                    .font(.headline)
            }
            
            HStack {
                Image(systemName: order.deliveryMethod == "delivery" ? "truck.box.fill" : "location.fill")
                    .font(.title2)
                    .foregroundColor(.orange)
                    .frame(width: 50, height: 50)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(order.deliveryMethod == "delivery" ? "Home Delivery" : "Store Pickup")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Text(order.deliveryMethod == "delivery" ? "Delivered to your address" : "Pick up from store")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding()
            .background(Color(.systemGray6).opacity(0.3))
            .cornerRadius(12)
        }
    }
}

// MARK: - Detail Row
struct DetailRow: View {
    let title: String
    let value: String
    var icon: String?
    
    var body: some View {
        HStack(spacing: 12) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.blue)
                    .frame(width: 40, height: 40)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(8)
    }
}

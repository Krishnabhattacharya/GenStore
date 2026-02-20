//
//  home_screen_components.swift
//  10Store
//
//  Created by Krishna Bhattacharya on 20/11/25.
//
import SwiftUI

struct UpperRow: View {
    @EnvironmentObject var homeVM: HomeViewModel

    var body: some View {
        HStack(spacing: 20) {
            Button(action: {
                print("🖼️ User image tapped")
                homeVM.toggleDrawer()
            }) {
                Image("user")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .shadow(radius: 4)
            }
            
            HStack(spacing: 20) {
                Button(action: {
                    print("👔 Men tab tapped")
                    homeVM.changeTab(to: 0)
                }) {
                    Text("All")
                        .font(.title3)
                        .foregroundColor(homeVM.tabInd == 0 ? .blue : .black)
                }
                   
                Button(action: {
                    print("👗 Women tab tapped")
                    homeVM.changeTab(to: 1)
                }) {
                    Text("Men")
                        .font(.title3)
                        .foregroundColor(homeVM.tabInd == 1 ? .blue : .black)
                }
                
                Button(action: {
                    print("👦 Boy tab tapped")
                    homeVM.changeTab(to: 2)
                }) {
                    Text("Women")
                        .font(.title3)
                        .foregroundColor(homeVM.tabInd == 2 ? .blue : .black)
                }
                
                Button(action: {
                    print("👧 Girl tab tapped")
                    homeVM.changeTab(to: 3)
                }) {
                    Text("Kids")
                        .font(.title3)
                        .foregroundColor(homeVM.tabInd == 3 ? .blue : .black)
                }
            }
         
            Spacer()
        }
        .padding()
        .frame(height: 80)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.9))
                .shadow(color: .black.opacity(0.1), radius: 5, y: 2)
        )
        .padding(.horizontal)
    }
}
struct BottomRow: View {
    let productIndex: Int
    @EnvironmentObject var homeVM: HomeViewModel
        private var currentProduct: Product? {
        guard let products = homeVM.productResponseModel?.products,
              products.indices.contains(productIndex) else {
            return nil
        }
        return products[productIndex]
    }
    
    private var colors: [String] {
        currentProduct?.colors ?? []
    }

    
    private var sizes: [Size]? {
        currentProduct?.sizes
    }
    
    private var price: Double? {
        currentProduct?.price
    }

    var body: some View {
        VStack {
            VStack {
                HStack {
                    if let colors =  currentProduct?.colors{    ForEach(colors, id: \.self) { colorName in
                        colorBox(colorName: colorName)
                    }
                        Spacer()
                    }
                }
                
                HStack {
                    if let sizes = currentProduct?.sizes {
                        ForEach(sizes, id: \.id) { size in
                            sizeBox(size: size.sizeName ?? "-")
                        }
                    }


                    Spacer()

                    if let price = price {
                        priceText(price: price)
                    }

                    Spacer().frame(width: 50)
                }

            }
            .frame(maxWidth: .infinity, maxHeight: 100)
            .padding(.leading, 20)
            .background(topBackground)
            
            actionButtons
        }
    }
    
    
    private func colorBox(colorName: String) -> some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(Color.from(name: colorName))
            .frame(width: 20, height: 20)
    }

    
    private func sizeBox(size: String) -> some View {
        Text(size)
            .foregroundColor(.black)
            .frame(width: 30, height: 30)
            .background(Color.white)
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.black.opacity(0.2), lineWidth: 1)
            )
    }

    
    private func priceText(price: Double) -> some View {
        Text("Rs: \(Int(price))/-")
            .font(.title3)
            .fontWeight(.bold)
    }

    
    private var topBackground: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.white.opacity(0.9))
            .shadow(color: .black.opacity(0.1), radius: 5, y: -2)
    }
    
    private var actionButtons: some View {
        HStack {
            cartButton
            Spacer()
            whatsappButton
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 100)
        .padding(.horizontal)
    }
    
    private var cartButton: some View {
        Image("cart_icon")
            .resizable()
            .padding()
            .scaledToFill()
            .frame(width: 60, height: 60)
            .background(.white)
            .clipShape(Circle())
            .shadow(radius: 5)
    }
    
    private var whatsappButton: some View {
        Image("whatsapp_icon")
            .resizable()
            .padding()
            .scaledToFill()
            .frame(width: 60, height: 60)
            .background(.white)
            .clipShape(Circle())
            .shadow(radius: 5)
    }
}
extension Color {
    static func from(name: String) -> Color {
        switch name.lowercased() {
        case "red": return .red
        case "black": return .black
        case "white": return .white
        case "blue": return .blue
        case "green": return .green
        case "yellow": return .yellow
        case "gray": return .gray
        case "orange": return .orange
        case "pink": return .pink
        case "purple": return .purple
        case "brown": return .brown
        default:
            return .clear
        }
    }
}
#Preview{
    HomeScreen()
}

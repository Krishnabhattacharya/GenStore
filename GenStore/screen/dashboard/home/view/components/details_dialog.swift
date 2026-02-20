//
//  DetailsDialog.swift
//  10Store
//
//  Created by Krishna Bhattacharya on 21/11/25.
//

import SwiftUI

struct DetailsDialog: View {

    let product: Product
    let onConfirm: () -> Void
    let onCancel: () -> Void

    @EnvironmentObject var vm: HomeViewModel

    @State private var selectedSize: Size?
    @State private var selectedColor: String = ""
    @State private var showToast: Bool = false

    var body: some View {
        ZStack {

            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { onCancel() }

            VStack(spacing: 16) {

                HStack {
                    Spacer()
                    Button(action: onCancel) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .padding(6)
                    }
                }

                HStack(spacing: 16) {
                    AsyncImage(url: URL(string: product.assets?.first?.url ?? "")) { img in
                        img.resizable()
                            .scaledToFill()
                            .frame(width: 130, height: 180)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } placeholder: {
                        ProgressView()
                            .frame(width: 130, height: 180)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text(product.title ?? "")
                            .font(.title2)
                            .bold()

                        Text(product.description ?? "")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .lineLimit(5)
                    }
                }

                Divider()

                HStack {
                    DropDownMenu(
                        colors: product.colors ?? [],
                        selectedColor: $selectedColor
                    )

                    Spacer()

                    HStack(spacing: 12) {
                        Button { vm.decreaseProductCount() } label: {
                            Text("-")
                                .frame(width: 30, height: 30)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .shadow(radius: 1)
                        }

                        Text("\(vm.productCount)")
                            .bold()
                            .font(.title3)

                        Button { vm.increaseProductCount() } label: {
                            Text("+")
                                .frame(width: 30, height: 30)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .shadow(radius: 1)
                        }
                    }
                    .padding(.trailing)
                }

                SizeSection(
                    sizes: product.sizes ?? [],
                    selectedSize: $selectedSize
                )

                HStack(spacing: 12) {

                    Button {
                        Task {
                            let req = CartRequestModel(
                                productID: product.id,
                                quantity: vm.productCount,
                                size: selectedSize?.sizeName,
                                color: selectedColor,
                                price: Int(product.price ?? 0.0),
                                image: product.assets?.first?.url,
                                title: product.title,
                                shortDiscription: product.description ?? "No Des"
                            )

                            await vm.addToCart(req: req)
                            
                            await MainActor.run {
                                showToast = true
                            }
                        }
                    } label: {
                        ZStack {
                            if vm.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            } else {
                                Text("Add to cart")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(10)
                    }
                    .disabled(selectedSize == nil || selectedColor.isEmpty || vm.isLoading)

                    Button {} label: {
                        Text("WhatsApp")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.3))
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .frame(maxWidth: 350)
            .shadow(radius: 25)
        }
        .toast(
            isPresenting: $showToast,
            message: "Product add to cart Successful",
            icon: .success,
            textColor: .green,
            onDisappear: {
                onConfirm()
            }
        )
        .onChange(of: vm.showSuccessToast) { newValue in
            if newValue {
                showToast = true
                vm.showSuccessToast = false             }
        }
    }
}

//////////////////////////////////////////////////////////////
// MARK: - DropDownMenu
//////////////////////////////////////////////////////////////

struct DropDownMenu: View {

    let colors: [String]
    @Binding var selectedColor: String

    var body: some View {
        HStack {
            Text("Color:")
                .font(.title2)

            Picker("Choose color", selection: $selectedColor) {
                ForEach(colors, id: \.self) { color in
                    Text(color)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
        .onAppear {
            if selectedColor.isEmpty {
                selectedColor = colors.first ?? ""
            }
        }
        .padding(.leading, 20)
    }
}

//////////////////////////////////////////////////////////////
// MARK: - SizeSection
//////////////////////////////////////////////////////////////

struct SizeSection: View {

    let sizes: [Size]
    @Binding var selectedSize: Size?

    var body: some View {
        VStack(alignment: .leading) {

            HStack {
                Text("Size:")
                    .font(.title2)

                Text(selectedSize?.sizeName ?? "")
                    .font(.title2)
                    .bold()
            }
            .padding(.leading, 20)
            .padding(.top, 20)

            VStack {
                HStack(alignment: .top) {

                    VStack(alignment: .leading, spacing: 20) {
                        Text("Weight Range").font(.headline)
                        Text("Size Name").font(.headline)
                    }
                    .frame(width: 120)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(sizes, id: \.id) { size in
                                SizeCell(
                                    size: size,
                                    isSelected: size.id == selectedSize?.id
                                )
                                .onTapGesture {
                                    selectedSize = size
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black))
            .padding(.horizontal, 20)
        }
        .onAppear {
            selectedSize = sizes.first
        }
    }
}

//////////////////////////////////////////////////////////////
// MARK: - SizeCell
//////////////////////////////////////////////////////////////

struct SizeCell: View {

    let size: Size
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 20) {

            Text(size.weightRange ?? "")
                .font(.caption)

            Divider()

            Text(size.sizeName ?? "")
                .font(.caption)
                .bold()
        }
        .frame(width: 60)
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isSelected ? Color.blue.opacity(0.2) : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? Color.blue : Color.gray, lineWidth: 1)
        )
        .animation(.easeInOut, value: isSelected)
    }
}

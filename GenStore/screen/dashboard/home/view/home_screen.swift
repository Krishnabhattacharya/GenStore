
import SwiftUI
import AVKit

struct HomeScreen: View {
    @State private var scrollPosition: Int? = 0
    @State private var currentAssetPages: [Int: Int] = [:]
    
    @State private var showAlert = false
    @EnvironmentObject var homeVM: HomeViewModel

    var body: some View {
        ZStack(alignment: .leading) {
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    
                    let products = homeVM.productResponseModel?.products ?? []

                    ForEach(products.indices, id: \.self) { index in
                        let product = products[index]
                        let assets = product.assets ?? []
                        let currentPage = currentAssetPages[index] ?? 0

                        ZStack {
                            if assets.indices.contains(currentPage) {
                                let asset = assets[currentPage]
                                
                                if asset.type?.lowercased() == "image",
                                   let urlString = asset.url,
                                   let url = URL(string: urlString) {

                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        case .failure:
                                            Image(systemName: "photo")
                                                .font(.largeTitle)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                    .frame(width: UIScreen.main.bounds.width,
                                           height: UIScreen.main.bounds.height)
                                    .background(Color.black)
                                    .clipped()
                                    .onTapGesture { homeVM.toggleRow() }
                                }
                                else if asset.type?.lowercased() == "video",
                                        let urlString = asset.url,
                                        let url = URL(string: urlString) {

                                    VideoPlayer(player: AVPlayer(url: url))
                                        .frame(width: UIScreen.main.bounds.width,
                                               height: UIScreen.main.bounds.height)
                                        .aspectRatio(contentMode: .fill)
                                }
                                else {
                                    Image(systemName: "doc")
                                        .foregroundColor(.gray)
                                        .frame(width: UIScreen.main.bounds.width,
                                               height: UIScreen.main.bounds.height)
                                }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width,
                               height: UIScreen.main.bounds.height)
                        .id(index)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $scrollPosition)
            .ignoresSafeArea()

       
            VStack(spacing: 0) {
                Spacer().frame(height: 60)

                if !homeVM.isShowRaw {
                    UpperRow()
                }

                Spacer()

                if !homeVM.isShowRaw {
                    BottomRow(productIndex: scrollPosition ?? 0)
                        .onTapGesture { showAlert = true }
                }

                Spacer().frame(height: 60)
            }
            
            if let currentIndex = scrollPosition,
               let products = homeVM.productResponseModel?.products,
               products.indices.contains(currentIndex) {
                
                let assets = products[currentIndex].assets ?? []
                controlsView(
                    assetsCount: assets.count,
                    currentProductIndex: currentIndex
                )
            }
            if homeVM.isOpenDrawer {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation { homeVM.toggleDrawer() }
                    }

                HStack {
                    VStack {
                        Spacer().frame(height: 50)
                        Drawer()
                        Spacer().frame(height: 50)
                    }
                    .transition(.move(edge: .leading))

                    Spacer()
                }
            }

            // Alert dialog
            if showAlert {
                let ind=scrollPosition ?? 0
                    if let product = homeVM.productResponseModel?.products?[ind]{
                    DetailsDialog(
                        product: product,
                        onConfirm: { showAlert = false },
                        onCancel: { showAlert = false }
                    )
                }
            }
        }
        .task {
            await homeVM.getProduct(type: "all")
        }
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
    }

    private func controlsView(assetsCount: Int, currentProductIndex: Int) -> some View {
        HStack {
            // Only show arrows if there are multiple assets
            if assetsCount > 1 {
                // Previous button
                Button(action: { previousPage(for: currentProductIndex) }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                        .frame(width: 50, height: 50)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 2)
                }
                .opacity(getCurrentPage(for: currentProductIndex) > 0 ? 1 : 0.5)
                .disabled(getCurrentPage(for: currentProductIndex) <= 0)
            }

            Spacer()
            
            // Page indicators in the center
            if assetsCount > 1 {
                VStack {
                    Spacer()
                    HStack(spacing: 8) {
                        ForEach(0..<assetsCount, id: \.self) { pageIndex in
                            Circle()
                                .fill(pageIndex == getCurrentPage(for: currentProductIndex) ? Color.white : Color.white.opacity(0.5))
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
            
            Spacer()

            if assetsCount > 1 {
                // Next button
                Button(action: { nextPage(for: currentProductIndex, length: assetsCount) }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                        .frame(width: 50, height: 50)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 2)
                }
                .opacity(getCurrentPage(for: currentProductIndex) < assetsCount - 1 ? 1 : 0.5)
                .disabled(getCurrentPage(for: currentProductIndex) >= assetsCount - 1)
            }
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // Helper functions for page management
    func getCurrentPage(for productIndex: Int) -> Int {
        return currentAssetPages[productIndex] ?? 0
    }

    func nextPage(for productIndex: Int, length: Int) {
        guard length > 0 else { return }
        let currentPage = getCurrentPage(for: productIndex)
        guard currentPage < length - 1 else { return }
        
        withAnimation {
            currentAssetPages[productIndex] = currentPage + 1
        }
    }

    func previousPage(for productIndex: Int) {
        let currentPage = getCurrentPage(for: productIndex)
        guard currentPage > 0 else { return }
        
        withAnimation {
            currentAssetPages[productIndex] = currentPage - 1
        }
    }
}

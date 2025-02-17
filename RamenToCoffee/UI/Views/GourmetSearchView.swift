//
//  ContentView.swift
//  RamenToCoffee
//
//  Created by Sora Oya on 2025/01/25.
//

import SwiftUI

struct GourmetSearchView: View {
    @StateObject
    var viewModel: GourmetSearchViewModel

    var body: some View {
        VStack {
            SearchBar { text in
                await viewModel.fetchGourmet(keyword: text)
            }
            if viewModel.isNoGourmet {
                noGourmetsView()
            } else {
                GourmetList(gourmetShops: viewModel.gourmets)
            }
        }
        .padding(.top)
        .padding(.horizontal)
        .background(Color.lightGray)
        .onAppear {
            viewModel.checkLocationAuthorization()
        }
        .onChange(of: viewModel.authorizationStatus) { status in
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                Task {
                    await viewModel.loadLocation()
                }
            case .denied, .restricted:
                print("Location access denied or restricted.")
            case .notDetermined:
                print("Waiting for location authorization.")
            default:
                break
            }
        }
        .alert($viewModel.error)
        .loading(isPresented: viewModel.isLoading)
    }
    
    private func noGourmetsView() -> some View {
        ScrollView {
            Text("条件に合うお店が見つかりませんでした")
                .padding(.top)
                .padding(.top)
                .alignment(.center)
        }
    }
}

private struct SearchBar: View {
    @State var searchText: String = ""
    var searchAction: @MainActor (String) async -> Void

    @FocusState
    private var isFocused: Bool

    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .frame(height: 36)

                HStack(spacing: 6) {
                    Spacer()
                        .frame(width: 0)
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("店名、キーワード", text: $searchText)
                        .focused($isFocused)
                    ClearButton {
                        searchText = ""
                        await submitSearchText()
                    }
                }
            }
            .padding(.horizontal)
        }
        .onChange(of: isFocused) { newValue in
            guard !newValue else { return }
            Task {
                await submitSearchText()
            }
        }
    }

    @MainActor
    private func submitSearchText() async {
        await searchAction(searchText)
    }
}

private struct GourmetList: View {
    var gourmetShops: [GourmetSearchViewModel.Gourmet]
    
    var body: some View {
        ScrollView {
            ForEach(gourmetShops, id: \.self) { gourmetShop in
                Row(
                    name: gourmetShop.name,
                    catchText: gourmetShop.catchText ?? "",
                    access: gourmetShop.access ?? "",
                    genreText: gourmetShop.genreText ?? "",
                    stationName: gourmetShop.stationName ?? "",
                    budgetText: gourmetShop.budgetText ?? "",
                    open: gourmetShop.open ?? "",
                    close: gourmetShop.close ?? "",
                    logoImageURL: gourmetShop.logoImageURL
                )
            }
        }
    }
}

private struct Row: View {
    var name: String
    var catchText: String
    var access: String
    var genreText: String
    var stationName: String
    var budgetText: String
    var open: String
    var close: String
    var logoImageURL: URL?

    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: logoImageURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height:  200)
                        .clipped()
                case .failure(_):
                    Image(systemName: "photo")
                        .frame(height: 200)
                case .empty:
                    ProgressView()
                @unknown default:
                    EmptyView()
                }
            }
            VStack(alignment: .leading, spacing: 15) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(name)
                        .font(.headline)
                    Text(catchText)
                        .foregroundStyle(.gray)
                }
                Label(genreText, systemImage: "fork.knife")
                HStack(alignment: .top) {
                    Image(systemName: "calendar")
                    VStack(alignment: .leading, spacing: 8) {
                        Text("営業時間: \(open)")
                        Divider()
                        Text("定休日: \(close)")
                    }
                }
                HStack(alignment: .top, spacing: 3) {
                    Label(stationName, systemImage: "mappin")
                    Text("/")
                    Text(access)
                }
                Label(budgetText, systemImage: "yensign")
            }
            .font(.footnote)
            .padding()
        }
        .background(.white)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 1, y: 5)
        .padding(5)
    }
}

#Preview {
    GourmetSearchView(viewModel: .init())
}

#Preview {
    GourmetList(
        gourmetShops: [.init(
            name: "松富",
            catchText: "銀座グルメが集まるラーメン屋さん",
            stationName: "銀座",
            access: "駅近好立地◎日比谷駅徒歩約8分有楽町駅徒歩約8分",
            genreText: "ラーメン",
            budgetText: "1501～2000円",
            open: "月～金／11：30～14：00",
            close: "日",
            logoImageURL: .init(string: "https://imgfp.hotp.jp/IMGH/75/07/P043717507/P043717507_238.jpg")
        )]
    )
}

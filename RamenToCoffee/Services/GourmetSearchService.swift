//
//  GourmetSearchService.swift
//  RamenToCoffee
//
//  Created by Sora Oya on 2025/02/04.
//

import API
import Foundation

struct GourmetSearchService {
    var gourmetSearchAPI: GourmetSearchAPI = .init(apiClient: .default)
    
    func fetchGourmet() async throws -> [GourmetSearch] {
        let response = try await gourmetSearchAPI.get(.init())
        return response.result.shop.map { shop in
            .init(
                id: shop.id,
                name: shop.name,
                logoImageURL: .init(string: shop.logo_image),
                address: shop.address,
                stationName: shop.station_name,
                lat: shop.lat,
                lng: shop.lng,
                genreText: shop.genre.name,
                budgetText: shop.budget.name,
                budgetAverage: shop.budget.average,
                largeImageURL: .init(string: shop.photo.mobile.l),
                midiumImageURL: .init(string: shop.photo.mobile.m),
                smallImageURL: .init(string: shop.photo.mobile.s)
            )
        }
    }
}

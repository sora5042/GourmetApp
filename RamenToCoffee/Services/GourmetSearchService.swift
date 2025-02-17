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

    func fetchGourmet(keyword: String, latitude: Double, longitude: Double) async throws -> [GourmetSearch] {
        let response = try await gourmetSearchAPI.get(.init(keyword: keyword, lat: latitude, lng: longitude))
        return response.results.shop.map { shop in
            .init(
                id: shop.id,
                name: shop.name,
                catchText: shop.catch,
                logoImageURL: URL(string: shop.photo?.mobile?.l ?? ""),
                address: shop.address,
                stationName: shop.station_name,
                access: shop.mobile_access,
                lat: shop.lat,
                lng: shop.lng,
                genreText: shop.genre.name,
                budgetText: shop.budget.name,
                budgetAverage: shop.budget.average,
                open: shop.open,
                close: shop.close,
                largeImageURL: URL(string: shop.photo?.mobile?.l ?? ""),
                smallImageURL: URL(string: shop.photo?.mobile?.s ?? "")
            )
        }
    }
}

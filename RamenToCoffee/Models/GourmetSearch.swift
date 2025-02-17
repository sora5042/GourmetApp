//
//  GourmetSearch.swift
//  RamenToCoffee
//
//  Created by Sora Oya on 2025/02/04.
//

import Foundation

struct GourmetSearch: Hashable {
    let id: String
    let name: String
    let catchText: String
    let logoImageURL: URL?
    let address: String
    let stationName: String
    let access: String
    let lat: Double
    let lng: Double
    let genreText: String
    let budgetText: String
    let budgetAverage: String
    let open: String
    let close: String
    let largeImageURL: URL?
    let smallImageURL: URL?
}

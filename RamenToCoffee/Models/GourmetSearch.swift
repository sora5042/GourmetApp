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
    let logoImageURL: URL?
    let address: String
    let stationName: String
    let lat: Double
    let lng: Double
    let genreText: String
    let budgetText: String
    let budgetAverage: String
    let largeImageURL: URL?
    let midiumImageURL: URL?
    let smallImageURL: URL?
}

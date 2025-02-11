//
//  GourmetSearchViewModel.swift
//  RamenToCoffee
//
//  Created by Sora Oya on 2025/02/04.
//

import CoreLocation
import Foundation

final class GourmetSearchViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    let gourmetSearchService: GourmetSearchService
    private let clLocationManager: CLLocationManager

    @Published
    var coordinate: CLLocationCoordinate2D?

    @Published
    private(set) var gourmets: [Gourmet] = []

    init(
        gourmetSearchService: GourmetSearchService = .init(),
        clLocationManager: CLLocationManager = .init()
    ) {
        self.gourmetSearchService = gourmetSearchService
        self.clLocationManager = clLocationManager
        super.init()
        self.clLocationManager.delegate = self
        self.clLocationManager.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        coordinate = location.coordinate
        Task {
            await fetchGourmet(latitude: coordinate?.latitude ?? 0, longitude: coordinate?.longitude ?? 0)
        }
    }

    private func startUpdates() {
        clLocationManager.startUpdatingLocation()
    }

    func checkLocationServicesEnabled() {
        Task { [weak self] in
            for await _ in Timer.publish(every: 30, on: .main, in: .common).autoconnect().values {
                if CLLocationManager.locationServicesEnabled() {
                    self?.startUpdates()
                } else {
                    // 位置情報サービスが無効の場合の処理
                    print("Location services are disabled")
                }
            }
        }
    }

    private func fetchGourmet(keyword: String? = nil, latitude: Double, longitude: Double) async {
        do {
            let gourmets = try await gourmetSearchService.fetchGourmet(keyword: keyword ?? "グルメ", latitude: latitude, longitude: longitude)
            self.gourmets = gourmets.map { .init(gourmetSearch: $0) }
        } catch {
            print(error)
        }
    }
}

extension GourmetSearchViewModel {
    struct Gourmet: Hashable {
        var name: String
        var logoImageURL: URL?
    }
}

extension GourmetSearchViewModel.Gourmet {
    init(gourmetSearch: GourmetSearch) {
        self.init(
            name: gourmetSearch.name,
            logoImageURL: gourmetSearch.logoImageURL
        )
    }
}


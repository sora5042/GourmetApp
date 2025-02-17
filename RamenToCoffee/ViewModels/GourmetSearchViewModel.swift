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
    private let locationManager: CLLocationManager

    @Published
    var authorizationStatus: CLAuthorizationStatus?

    @Published
    var coordinate: CLLocationCoordinate2D?

    @Published
    private(set) var gourmets: [Gourmet] = []
    
    private var isFirstFetch: Bool = false

    init(
        gourmetSearchService: GourmetSearchService = .init(),
        clLocationManager: CLLocationManager = .init()
    ) {
        self.gourmetSearchService = gourmetSearchService
        self.locationManager = clLocationManager
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        coordinate = location.coordinate
        if !isFirstFetch {
            isFirstFetch = true
            Task {
                await fetchGourmet(keyword: "")
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.authorizationStatus = status
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        if manager.authorizationStatus == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
    
    func loadLocation() async {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        } else {
            print("Location services are disabled.")
        }
    }

    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            // 位置情報の使用が拒否されている場合の処理
            print("Location use is denied or restricted")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }

    @MainActor
    func fetchGourmet(keyword: String = "") async {
        guard let coordinate = coordinate else {
            await loadLocation()
            return
        }
        do {
            let gourmets = try await gourmetSearchService.fetchGourmet(keyword: keyword.isEmpty ? "グルメ" : keyword, latitude: coordinate.latitude, longitude: coordinate.longitude)
            self.gourmets = gourmets.map { .init(gourmetSearch: $0) }
        } catch {
            print(error)
        }
    }
}

extension GourmetSearchViewModel {
    struct Gourmet: Hashable {
        var name: String
        var catchText: String?
        var stationName: String?
        var access: String?
        var genreText: String?
        var budgetText: String?
        var open: String?
        var close: String?
        var logoImageURL: URL?
    }
}

extension GourmetSearchViewModel.Gourmet {
    init(gourmetSearch: GourmetSearch) {
        self.init(
            name: gourmetSearch.name,
            catchText: gourmetSearch.catchText,
            stationName: gourmetSearch.stationName,
            access: gourmetSearch.access,
            genreText: gourmetSearch.genreText,
            budgetText: gourmetSearch.budgetText,
            open: gourmetSearch.open,
            close: gourmetSearch.close,
            logoImageURL: gourmetSearch.logoImageURL
        )
    }
}


//
//  GourmetSearch.swift
//  RamenToCoffee
//
//  Created by Sora Oya on 2025/02/02.
//

import Foundation

public struct GourmetSearch: Decodable {
    public let results: Results
}

extension GourmetSearch {
    public struct Results: Decodable {
        public let results_available: Int
        public let shop: [Shop]
    }
}

extension GourmetSearch {
    public struct Shop: Decodable {
        public let id: String
        public let name: String
        public let logo_image: String
        public let name_kana: String
        public let address: String
        public let station_name: String
        public let lat: Double
        public let lng: Double
        public let genre: Genre
        public let budget: Budget
        public let `catch`: String
        public let capacity: Int
        public let access: String
        public let mobile_access: String
        public let urls: URLs?
        public let photo: Photo?
        public let open: String
        public let close: String
    }
    
    public struct Genre: Decodable {
        public let name: String
        public let `catch`: String
    }
    
    public struct Budget: Decodable {
        public let name: String
        public let average: String
    }
    
    public struct URLs: Decodable {
        public let pc: String?
    }
    
    public struct Photo: Decodable {
        public let mobile: Mobile?
    }
    
    public struct Mobile: Decodable {
        public let l: String?
        public let s: String?
    }
}

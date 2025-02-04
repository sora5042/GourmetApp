//
//  GourmetSearchAPI.swift
//  RamenToCoffee
//
//  Created by Sora Oya on 2025/02/02.
//

public struct GourmetSearchAPI: APIEndpoint {
    public init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    public let apiClient: APIClient
    public let path = "gourmet/v1/"

    @discardableResult
    public func get(_ param: GetParam) async throws -> GourmetSearch {
        try await apiClient.response(path: path, parameters: param)
    }
}

extension GourmetSearchAPI {
    /// リクエスト用パラメータ
    public struct GetParam: Encodable {
        public init(id: Int? = nil, name: String? = nil, name_kana: String? = nil, name_any: String? = nil, tel: Int? = nil, address: String? = nil, keyword: String? = nil, range: String? = nil) {
            self.id = id
            self.name = name
            self.name_kana = name_kana
            self.name_any = name_any
            self.tel = tel
            self.address = address
            self.keyword = keyword
            self.range = range
        }

        /// お店ID
        public var id: Int?
        /// 掲載店名
        public var name: String?
        /// 掲載店名かな
        public var name_kana: String?
        /// 掲載店名 OR かな
        public var name_any: String?
        /// 電話番号
        public var tel: Int?
        /// 住所
        public var address: String?
        /// キーワード
        public var keyword: String?
        /// 範囲
        public var range: String?
        /// 検索ヒット数
        public var count: String?
    }
}

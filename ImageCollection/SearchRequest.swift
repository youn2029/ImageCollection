//
//  SearchRequest.swift
//  ImageCollection
//
//  Created by 윤성호 on 2025/02/15.
//

import Foundation

enum SearchSort: String {
    case accuracy, recency
}

public struct SearchRequest: Encodable {
    public let query: String
    public let sort: String
    public let page: Int
    public var size: Int
    
    init(
        query: String,
        sort: String = SearchSort.recency.rawValue,
        page: Int = 1,
        size: Int = 20
    ) {
        self.query = query
        self.sort = sort
        self.page = page
        self.size = size
    }
}

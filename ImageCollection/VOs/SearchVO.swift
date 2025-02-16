//
//  SearchVO.swift
//  ImageCollection
//
//  Created by 윤성호 on 2025/02/14.
//

import Foundation

public struct SearchVO {
    public let thumbnail: String
    public let doc_url: String
    public let datetime: Date
    public var isFavorite: Bool
    
    init(thumbnail: String, doc_url: String, datetime: Date = .now, isFavourite: Bool = false) {
        self.thumbnail = thumbnail
        self.doc_url = doc_url
        self.datetime = datetime
        self.isFavorite = isFavourite
    }
}

public extension SearchVO {
    static func stub() -> Self {
        .init(
            thumbnail: "https://search2.kakaocdn.net/argon/130x130_85_c/36hQpoTrVZp",
            doc_url: "http://v.media.daum.net/v/20170621155930002",
            datetime: .now,
            isFavourite: false
        )
    }
}

//
//  ImageDTO.swift
//  ImageCollection
//
//  Created by 윤성호 on 2025/02/12.
//

import Foundation

public struct ImageDTO: DTOProtocol {
    let collection: String
    let thumbnail_url: String
    let image_url: String
    let width: Int
    let height: Int
    let display_sitename: String
    let doc_url: String
    let datetime: Date?
    
    enum CodingKeys: CodingKey {
        case collection, thumbnail_url, image_url, width, height, display_sitename, doc_url, datetime
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        collection = try! values.decode(String.self, forKey: .collection)
        thumbnail_url = try! values.decode(String.self, forKey: .thumbnail_url)
        image_url = try! values.decode(String.self, forKey: .image_url)
        width = try! values.decode(Int.self, forKey: .width)
        height = try! values.decode(Int.self, forKey: .height)
        display_sitename = try! values.decode(String.self, forKey: .display_sitename)
        doc_url = try! values.decode(String.self, forKey: .doc_url)
        datetime = Date.parse(values, key: .datetime)
    }
    
    public init(
        collection: String = "",
        thumbnail_url: String = "",
        image_url: String = "",
        width: Int = 0,
        height: Int = 0,
        display_sitename: String = "",
        doc_url: String = "",
        datetime: Date? = nil
    ) {
        self.collection = collection
        self.thumbnail_url = thumbnail_url
        self.image_url = image_url
        self.width = width
        self.height = height
        self.display_sitename = display_sitename
        self.doc_url = doc_url
        self.datetime = datetime
    }
}

public extension ImageDTO {
    static func stub() -> Self {
        .init(
            collection: "news",
            thumbnail_url: "https://search2.kakaocdn.net/argon/130x130_85_c/36hQpoTrVZp",
            image_url: "http://t1.daumcdn.net/news/201706/21/kedtv/20170621155930292vyyx.jpg",
            width: 540,
            height: 457,
            display_sitename: "한국경제TV",
            doc_url: "http://v.media.daum.net/v/20170621155930002",
            datetime: .now
        )
    }
    
    func toDomain() -> SearchVO {
        .init(
            thumbnail: thumbnail_url,
            doc_url: doc_url,
            datetime: datetime!,
            isFavourite: false
        )
    }

}

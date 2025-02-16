//
//  VClipDTO.swift
//  ImageCollection
//
//  Created by 윤성호 on 2025/02/12.
//

import Foundation

public struct VClipDTO: DTOProtocol {
    let author: String
    let datetime: Date?
    let play_time: Int
    let thumbnail: String
    let title: String
    let url: String
    
    public init(
        author: String,
        datetime: Date,
        play_time: Int,
        thumbnail: String,
        title: String,
        url: String
    ) {
        self.author = author
        self.datetime = datetime
        self.play_time = play_time
        self.thumbnail = thumbnail
        self.title = title
        self.url = url
    }
    
    enum CodingKeys: CodingKey {
        case author, datetime, play_time, thumbnail, title, url
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        author = try! values.decode(String.self, forKey: .author)
        play_time = try! values.decode(Int.self, forKey: .play_time)
        thumbnail = try! values.decode(String.self, forKey: .thumbnail)
        title = try! values.decode(String.self, forKey: .title)
        url = try! values.decode(String.self, forKey: .url)
        datetime = Date.parse(values, key: .datetime)
    }
    
    public init(
        author: String = "",
        play_time: Int = 0,
        thumbnail: String = "",
        title: String = "",
        url: String = "",
        datetime: Date? = .now
    ) {
        self.author = author
        self.play_time = play_time
        self.thumbnail = thumbnail
        self.title = title
        self.url = url
        self.datetime = datetime
    }
}

public extension VClipDTO {
    static func stub() -> Self {
        .init(
            author: "SBS 옛날 예능 - 빽능",
            datetime: .now,
            play_time: 60,
            thumbnail: "https://search2.kakaocdn.net/argon/138x78_80_pr/JYem4zE5LVU",
            title: "설현귀닫아. #런닝맨",
            url: "http://www.youtube.com/watch?v=4ynZbIuAvQI"
        )
    }
    
    public func toDomain() -> SearchVO {
        .init(
            thumbnail: thumbnail,
            doc_url: url,
            datetime: datetime!,
            isFavourite: false
        )
    }
}

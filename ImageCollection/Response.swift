//
//  Response.swift
//  ImageCollection
//
//  Created by 윤성호 on 2025/02/12.
//

import Foundation

public struct Response<T: DTOProtocol>: ResponseProtocol {
    public let meta: Meta?
    public let documents: T?
    
    enum CodingKeys: CodingKey {
        case meta, documents
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        meta = (try? values.decode(Meta.self, forKey: .meta)) ?? nil
        documents = (try? values.decode(T.self, forKey: .documents)) ?? nil
    }
    
    public init(meta: Meta? = nil, documents: T? = nil) {
        self.meta = meta
        self.documents = documents
    }
}

public struct Meta: Codable {
    
    let is_end: Bool
    let pageable_count: Int
    let total_count: Int
    
    init(
        is_end: Bool,
        pageable_count: Int,
        total_count: Int
    ) {
        self.is_end = is_end
        self.pageable_count = pageable_count
        self.total_count = total_count
    }
}

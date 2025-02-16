//
//  DTOProtocol.swift
//  ImageCollection
//
//  Created by 윤성호 on 2025/02/16.
//

import Foundation

public protocol DTOProtocol: Codable {
    associatedtype VO
    func toDomain() -> VO
}

extension String: DTOProtocol {
    public typealias VO = String
    public func toDomain() -> VO {
        return self
    }
}

extension Array: DTOProtocol where Element: DTOProtocol {
    
    public func toDomain() -> [Element.VO] {
        self.map { $0.toDomain() }
    }
}

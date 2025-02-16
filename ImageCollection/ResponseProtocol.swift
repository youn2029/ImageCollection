//
//  ResponseProtocol.swift
//  ImageCollection
//
//  Created by 윤성호 on 2025/02/16.
//

import Foundation

public protocol ResponseProtocol: Codable {
    associatedtype DTO: DTOProtocol
    
    var meta: Meta? { get }
    var documents: DTO? { get }
}

extension ResponseProtocol {
    
    public func toDescription(with code: Int = 0) -> String {
        let meta = meta ?? nil
        let documents = documents ?? nil
        return "meta: \(String(describing: meta)), documents: \(String(describing: documents))"
    }
}

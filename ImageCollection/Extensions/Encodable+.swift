//
//  Encodable+.swift
//  ImageCollection
//
//  Created by 윤성호 on 2025/02/13.
//

import Foundation

extension Encodable {
    
    public var toDictionary : [String: Any]? {
        guard let object = try? JSONEncoder().encode(self) else { return nil }
        guard let dictionary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String:Any] else { return nil }
        return dictionary
    }
}


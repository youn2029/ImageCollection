//
//  CacheManager.swift
//  ImageCollection
//
//  Created by 윤성호 on 2025/02/16.
//

import Foundation

final class CacheManager {
    static let shared = CacheManager()
    private let cacheSearchs = NSCache<NSString, NSData>()
    
    init() {
        cacheSearchs.countLimit = 40
    }
    
    func loadData(_ queryText: String) -> NSData? {
        let key = NSString(string:queryText)
        if let cached = cacheSearchs.object(forKey: key) {
            return cached
        }
        return nil
    }
    
    func setData(queryText: String, data: NSData) {
        let key = NSString(string:queryText)
        cacheSearchs.setObject(data, forKey: key)
    }
    
    func removeData(_ queryText: String) {
        let key = NSString(string:queryText)
        cacheSearchs.removeObject(forKey: key)
    }
}

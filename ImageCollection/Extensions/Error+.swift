//
//  Error+.swift
//  ImageCollection
//
//  Created by 윤성호 on 2025/02/12.
//

import Foundation

public extension Error {
    var underlyingError: Error? {
        let nsError = self as NSError
        if nsError.domain == NSURLErrorDomain && nsError.code == -1009 {
            // "The Internet connection appears to be offline."
            return self
        }
        return nsError.userInfo[NSUnderlyingErrorKey] as? Error
    }
}

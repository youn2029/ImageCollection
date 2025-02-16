//
//  Console.swift
//  ImageCollection
//
//  Created by 윤성호 on 2025/02/13.
//

import Foundation

public struct Console {
    public static func log(_ message: String) {
        print("[LOG] \(message)")
    }
    
    public static func debug(_ message: String) {
        print("[DEBUG] \(message)")
    }
    
    public static func error(_ message: String) {
        print("[ERROR] \(message)")
    }
}

//
//  ComponentFrame.swift
//  ImageCollection
//
//  Created by 윤성호 on 2025/02/15.
//

import UIKit

public struct ComponentFrame {}

public extension ComponentFrame {
    static let deviceWidth: CGFloat = UIScreen.main.bounds.width
    static let deviceHeight: CGFloat = UIScreen.main.bounds.height
    
    static var safeAreaTopHeight: CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        return window?.safeAreaInsets.top ?? 47
    }
    
    static var safeAreaBottomHeight: CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        return window?.safeAreaInsets.bottom ?? 34
    }
    
    static var gridMaximumWidth: CGFloat {
        return (deviceWidth - 32 - 8)/2
    }
}

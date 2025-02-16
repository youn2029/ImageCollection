//
//  AppState.swift
//  ImageCollection
//
//  Created by 윤성호 on 2025/02/11.
//

import SwiftUI

struct AppState: Equatable {
    var view = ViewRouting()
    var system = System()
}

extension AppState {
    
    struct ViewRouting: Equatable {
        
    }
    
    struct System: Equatable {
    }
}

#if Dev || Stage
extension AppState {
    static var preview: AppState {
        var state = AppState()
        return state
    }
}
#endif

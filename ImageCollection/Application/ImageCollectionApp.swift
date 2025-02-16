//
//  ImageCollectionApp.swift
//  ImageCollection
//
//  Created by 윤성호 on 2025/02/11.
//

import SwiftUI

@main
struct ImageCollectionApp: App {
    let environment = AppEnvironment.bootstrap()

    var body: some Scene {
        WindowGroup {
            CollectionListView()
                .inject(environment.container)
        }
    }
}

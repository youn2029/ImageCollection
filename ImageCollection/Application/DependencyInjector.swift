//
//  DependencyInjector.swift
//  ImageCollection
//
//  Created by 윤성호 on 2025/02/11.
//

import SwiftUI
import Combine

struct DIContainer: EnvironmentKey {
    
    let appState: Store<AppState>
    let interactors: Interactors
    
    init(appState: Store<AppState>, interactors: Interactors) {
        self.appState = appState
        self.interactors = interactors
    }
    
    init(appState: AppState, interactors: Interactors) {
        self.init(appState: Store<AppState>(appState), interactors: interactors)
    }
    
    static var defaultValue: Self { Self.default }
    
    private static let `default` = Self(appState: AppState(), interactors: .stub)
}

extension DIContainer {
    struct WebRepositories {
    }
    
    struct DBRepositories {
    }
    
    struct Interactors {
        let searchInteractor: SearchInteractor
        let collectionInteractor: CollectionInteractor
        
        init(searchInteractor: SearchInteractor,
             collectionInteractor: CollectionInteractor
        ) {
            self.searchInteractor = searchInteractor
            self.collectionInteractor = collectionInteractor
        }
        
        static var stub: Self {
            .init(
                searchInteractor: StubSearchInteractor(),
                collectionInteractor: StubCollectionInteractor()
            )
        }
    }
}

extension EnvironmentValues {
    var injected: DIContainer {
        get { self[DIContainer.self] }
        set { self[DIContainer.self] = newValue }
    }
}

#if Dev || Stage
extension DIContainer {
    static var preview: Self {
        .init(appState: .init(AppState.preview), interactors: .stub)
    }
}
#endif

// MARK: - Injection in the view hierarchy

extension View {
    func inject(_ appState: AppState, _ interactors: DIContainer.Interactors) -> some View {
        let container = DIContainer(appState: .init(appState), interactors: interactors)
        return inject(container)
    }
    
    func inject(_ container: DIContainer) -> some View {
        return self
//            .modifier(RootViewAppearance())
            .environment(\.injected, container)
    }
}

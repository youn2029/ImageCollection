//
//  AppEnvironment.swift
//  ImageCollection
//
//  Created by 윤성호 on 2025/02/11.
//

import Foundation

struct AppEnvironment {
    let container: DIContainer
}

extension AppEnvironment {

    static func bootstrap() -> AppEnvironment {
        let appState = Store<AppState>(AppState())

        let session = configuredURLSession()
        let webRepositories = configureWebRepositories(session: session)
        let interactors = configureInteractors(
            appState: appState,
            webRepositories: webRepositories
        )

        let diContainer = DIContainer(appState: appState, interactors: interactors)
        return AppEnvironment(container: diContainer)
    }

    private static func configuredURLSession() -> URLSession {
        let cache = URLCache(memoryCapacity: 10 * 1024 * 1024, diskCapacity: 50 * 1024 * 1024, diskPath: nil)
        URLCache.shared = cache  // 전역 URLCache 설정
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        
        return URLSession(configuration: configuration)
    }

    private static func configureInteractors(appState: Store<AppState>,
                                             webRepositories: DIContainer.WebRepository) -> DIContainer.Interactors {

        let searchInteractor = RealSearchInteractor(
            appState: appState,
            searchRepository: webRepositories.searchWebRepository
        )
        let collectionRepository = RealCollectionRepository(coreDataStack: RealCoreDataStack.shared)
        let collectionInteractor = RealCollectionInteractor(repository: collectionRepository)
        
        return .init(
            searchInteractor: searchInteractor,
            collectionInteractor: collectionInteractor
        )
    }

    // MARK: - Repositories & Socket

    private static func configureWebRepositories(session: URLSession) -> DIContainer.WebRepository {
        let searchWebRepository = RealSearchWebRepository(
            session: session,
            baseURL: "https://dapi.kakao.com/v2/search"
        )
        
        return .init(
            searchWebRepository: searchWebRepository
        )
    }
}

extension DIContainer {
    struct WebRepository {
        let searchWebRepository: SearchWebRepository
    }
}

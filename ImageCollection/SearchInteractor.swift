//
//  SearchInteractor.swift
//  ImageCollection
//
//  Created by 윤성호 on 2025/02/13.
//

import Foundation
import Combine

protocol SearchInteractor {
    func searchList(param: SearchRequest) -> AnyPublisher<[SearchVO], Error>
}

final class RealSearchInteractor: SearchInteractor {
    var appState: Store<AppState>
    let searchRepository: SearchWebRepository
    private var disposeBag = Set<AnyCancellable>()
    
    init (
        appState: Store<AppState>,
        searchRepository: SearchWebRepository
    ) {
        self.appState = appState
        self.searchRepository = searchRepository
    }

    func searchList(param: SearchRequest) -> AnyPublisher<[SearchVO], Error> {
        searchRepository.imageSearchList(param: param)
            .combineLatest(searchRepository.vClipSearchList(param: param)){ $0+$1 }
            .resolveServerError(with: &appState)
    }
}

struct StubSearchInteractor: SearchInteractor {
    func searchList(param: SearchRequest) -> AnyPublisher<[SearchVO], Error> {
        return Just([
            SearchVO.stub(),
            SearchVO.stub()
        ])
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
}

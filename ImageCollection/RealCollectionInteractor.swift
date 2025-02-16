//
//  RealCollectionInteractor.swift
//  ImageCollection
//
//  Created by 윤성호 on 2025/02/16.
//

import Foundation
import Combine

public protocol CollectionInteractor {
    func fetchCollection() -> AnyPublisher<[CollectionVO], Error>
    func save(searchVo: SearchVO) -> AnyPublisher<Void, Error>
    func delete(id: UUID) -> AnyPublisher<Void, Error>
}

public final class RealCollectionInteractor: CollectionInteractor {
    private let repository: CollectionRepository
    
    public init(repository: CollectionRepository) {
        self.repository = repository
    }
    
    public func fetchCollection() -> AnyPublisher<[CollectionVO], Error> {
        return repository.fetch()
    }
    
    public func save(searchVo: SearchVO) -> AnyPublisher<Void, Error> {
        return repository.save(searchVo: searchVo)
    }
    
    public func delete(id: UUID) -> AnyPublisher<Void, Error> {
        return repository.delete(id: id)
    }
}

// MARK: - Stub
public final class StubCollectionInteractor: CollectionInteractor {
    var temp: [UUID]
    
    public init(temp: [UUID] = [UUID(), UUID()]) {
        self.temp = temp
    }
    
    public func fetchCollection() -> AnyPublisher<[CollectionVO], Error> {
        return Future<[CollectionVO], Error> { [weak self] promise in
            guard let strongSelf = self else { return }
            promise(
                .success(strongSelf.temp.map { _ in .stub() })
            )
        }
        .eraseToAnyPublisher()
    }
    
    public func save(searchVo: SearchVO) -> AnyPublisher<Void, Error> {
        
        return Empty().eraseToAnyPublisher()
    }
    
    public func delete(id: UUID) -> AnyPublisher<Void, Error> {
        return Empty().eraseToAnyPublisher()
    }
    
    
}

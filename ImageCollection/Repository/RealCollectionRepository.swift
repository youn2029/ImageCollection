//
//  RealCollectionRepository.swift
//  ImageCollection
//
//  Created by 윤성호 on 2025/02/16.
//

import Foundation
import Combine

public protocol CollectionRepository {
    func fetch() -> AnyPublisher<[CollectionVO], Error>
    func save(searchVo: SearchVO) -> AnyPublisher<Void, Error>
    func delete(id: UUID) -> AnyPublisher<Void, Error>
}

public final class RealCollectionRepository: CollectionRepository {
    let coreDataStack: CoreDataStack
    
    public init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    public func fetch() -> AnyPublisher<[CollectionVO], Error> {
        let subject = CurrentValueSubject<[CollectionVO], Error>([])
        let result = coreDataStack.fetch()
        let sortedResult = result.sorted { $0.saveDate! < $1.saveDate! }
        subject.send(Array(sortedResult))
        return subject.eraseToAnyPublisher()
    }
    
    public func save(searchVo: SearchVO) -> AnyPublisher<Void, Error> {
        let subject = PassthroughSubject<Void, Error>()
        coreDataStack.add(searchVo: searchVo)
        subject.send(completion: .finished)
        return subject.eraseToAnyPublisher()
    }
    
    public func delete(id: UUID) -> AnyPublisher<Void, Error> {
        let subject = PassthroughSubject<Void, Error>()
        coreDataStack.delete(id: id)
        subject.send(completion: .finished)
        return subject.eraseToAnyPublisher()
    }
}

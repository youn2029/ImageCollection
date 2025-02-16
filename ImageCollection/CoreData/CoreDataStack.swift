//
//  CollectionCoreDataRepository.swift
//  ImageCollection
//
//  Created by 윤성호 on 2025/02/15.
//

import Foundation
import CoreData

public protocol CoreDataStack {
    /// 디스크 저장
    func save()
    func fetch() -> [CollectionVO]
    func add(searchVo: SearchVO)
    func delete(id: UUID)
}

final class RealCoreDataStack: ObservableObject {
    static let shared = RealCoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CollectionData")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    private init() {}
}

extension RealCoreDataStack: CoreDataStack {
    
    func save() {
        guard persistentContainer.viewContext.hasChanges else { return }
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed to save the context:", error.localizedDescription)
        }
    }
    
    func fetch() -> [CollectionVO] {
        guard let array = try? persistentContainer.viewContext.fetch(CollectionCoreData.fetchRequest()) else {
            return []
        }
        return array.map { $0.toDomain() }
    }
    
    func add(searchVo: SearchVO) {
        
        let collection = CollectionCoreData(context: persistentContainer.viewContext)
        collection.setValue(UUID(), forKey: "id")
        collection.setValue(searchVo.thumbnail, forKey: "thumbnail")
        collection.setValue(searchVo.doc_url, forKey: "doc_url")
        collection.setValue(searchVo.datetime, forKey: "datetime")
        collection.setValue(Date(), forKey: "saveDate")
        
        save()
    }
    
    func delete(id: UUID) {
        guard let array = try? persistentContainer.viewContext.fetch(CollectionCoreData.fetchRequest()) else {
            print("[ERROR] CoreData가 존재하지 않습니다.")
            return
        }
        let target = array.filter { $0.id == id }.last!
        let context = target.managedObjectContext
        context?.delete(target)
        
        save()
    }
}

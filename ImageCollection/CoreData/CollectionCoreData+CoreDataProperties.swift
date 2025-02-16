//
//  CoreDataManagerProperties.swift
//  ImageCollection
//
//  Created by 윤성호 on 2025/02/16.
//

import Foundation
import CoreData

extension CollectionCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CollectionCoreData> {
        return NSFetchRequest<CollectionCoreData>(entityName: "CollectionCoreData")
    }

    @NSManaged public var id: UUID
    @NSManaged public var thumbnail: String
    @NSManaged public var doc_url: String
    @NSManaged public var datetime: Date
    @NSManaged public var saveDate: Date

}

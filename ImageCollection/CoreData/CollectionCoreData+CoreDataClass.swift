//
//  CoreDataManager.swift
//  ImageCollection
//
//  Created by 윤성호 on 2025/02/15.
//

import Foundation
import CoreData

@objc(CollectionCoreData)
public class CollectionCoreData: NSManagedObject {

}

extension CollectionCoreData {
    func toDomain() -> CollectionVO {
        .init(
            thumbnail: thumbnail,
            doc_url: doc_url,
            datetime: datetime,
            saveDate: saveDate
        )
    }
}

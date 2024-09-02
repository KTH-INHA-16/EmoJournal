//
//  WriteDataEntity+CoreDataProperties.swift
//  EmoJournal
//
//  Created by 김태훈 on 7/29/24.
//
//

import Foundation
import CoreData


extension WriteDataEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WriteDataEntity> {
        return NSFetchRequest<WriteDataEntity>(entityName: "WriteDataEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var content: String?
    @NSManaged public var imgData: Data?
    @NSManaged public var writeDate: Date?

}

extension WriteDataEntity : Identifiable {

}

enum CoreDataKey: String {
    case id, content, imgData, writeDate
}

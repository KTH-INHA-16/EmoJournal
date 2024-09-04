//
//  WriteDataEntity+CoreDataProperties.swift
//  EmoJournal
//
//  Created by 김태훈 on 9/4/24.
//
//

import Foundation
import CoreData


extension WriteDataEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WriteDataEntity> {
        return NSFetchRequest<WriteDataEntity>(entityName: "WriteDataEntity")
    }

    @NSManaged public var content: String?
    @NSManaged public var imgData: Data?
    @NSManaged public var writeDate: Date?
    @NSManaged public var id: UUID?

}

extension WriteDataEntity : Identifiable {

}

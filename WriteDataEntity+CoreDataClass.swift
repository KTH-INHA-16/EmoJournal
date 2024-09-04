//
//  WriteDataEntity+CoreDataClass.swift
//  EmoJournal
//
//  Created by 김태훈 on 9/4/24.
//
//

import Foundation
import CoreData

@objc(WriteDataEntity)
public class WriteDataEntity: NSManagedObject {

}

enum CoreDataKey: String {
    case content
    case imgData
    case writeDate
    case id
}

//
//  Persistence.swift
//  EmoJournal
//
//  Created by 김태훈 on 7/29/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    
    let container: NSPersistentCloudKitContainer
    
    init() {
        container = NSPersistentCloudKitContainer(name: "WriteDataModel")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func save(_ attributes: [String: Any]) -> Void {
        let entity = NSEntityDescription.entity(forEntityName: "WriteDataEntity", in: container.viewContext)
        
        container.newBackgroundContext().perform { [ weak container = self.container] in
            guard let container = container, let entity = entity else {
                return
            }
            
            let entityObject = NSManagedObject(entity: entity, insertInto: container.viewContext)
            attributes.forEach { entityObject.setValue($0.value, forKey: $0.key) }
            
            do {
                try container.viewContext.save()
            } catch let error {
                print(error)
            }
        }
    }
}

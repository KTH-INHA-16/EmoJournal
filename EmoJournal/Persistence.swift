//
//  Persistence.swift
//  EmoJournal
//
//  Created by 김태훈 on 7/29/24.
//

import CoreData

final class PersistenceController {
    static let shared = PersistenceController()
    
    private lazy var entity: NSEntityDescription? = {
        return NSEntityDescription.entity(forEntityName: "WriteDataEntity", in: container.viewContext)
    }()
    
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
    
    func save(_ attributes: [String: Any?]) -> Void {
        container.viewContext.perform { [ weak container = self.container, weak entity = self.entity] in
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
    
    func fetch<T: NSManagedObject>() -> [T] {
        do {
            let context = try container.viewContext.fetch(T.fetchRequest())
            guard let context = context as? [T] else {
                return []
            }
            
            return context
        } catch {
            return []
        }
    }
    
    func delete(predicate: NSPredicate? = nil) -> Void {
        container.viewContext.perform { [weak container = self.container, weak entity = self.entity] in
            guard let entity = entity, let entityName = entity.name else {
                return
            }
            
            let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: entityName)
            request.predicate = predicate
            
            do {
                let delete = NSBatchDeleteRequest(fetchRequest: request)
                try container?.viewContext.execute(delete)
                
            } catch let error {
                print(error)
            }
        }
    }
}

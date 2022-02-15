//
//  Store.swift
//  TawkDevTest
//
//  Created by rlogical-dev-59 on 14/02/22.
//

import CoreData
import Foundation

class Store {
    static var instance = Store()
    fileprivate var queue = OperationQueue()

    // persistent container for writing values
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TawkDevTest")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // json decoder instance
    var decoder: JSONDecoder

    init() {
        decoder = JSONDecoder()
        if let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext {
            decoder.userInfo[codingUserInfoKeyManagedObjectContext] = container.viewContext
        }
        // set queue for background task execution
        queue.qualityOfService = .background
    }

    func save() {
        queue.cancelAllOperations()
        queue.addOperation { [weak self] in
            if self == nil {
                return
            }
            try? self?.container.viewContext.save()
        }
    }

    func fetchUsers() -> [User] {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            let results = try container.viewContext.fetch(fetchRequest)
            return results
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func fetchUserData(id:Int) -> User? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %d", argumentArray: [id])
        fetchRequest.sortDescriptors = [.init(key: "notes", ascending: true)]
        fetchRequest.propertiesToFetch = ["notes"]
        do {
            let results = try container.viewContext.fetch(fetchRequest)
            return results.last
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func userHasNotes(id:Int) -> Bool {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %d", argumentArray: [id])
        fetchRequest.sortDescriptors = [.init(key: "notes", ascending: true)]
        fetchRequest.propertiesToFetch = ["notes"]
        do {
            let results = try container.viewContext.fetch(fetchRequest)
            return results.last?.notes != nil ? true : false
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}

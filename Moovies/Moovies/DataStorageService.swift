// DataStorageService.swift
// Copyright © RoadMap. All rights reserved.

import CoreData
import Foundation

protocol AccessableRepository {}

protocol DataStorageServiceProtocol {
    func save(object: Film)
    func get() -> Film
}

// DataStorageService
final class DataStorageService: DataStorageServiceProtocol {
    private let repository = Repository(dataBase: RealmMovies())

    func save(object: Film) {
        repository.save(obj: object)
    }

    func get() -> Film {
        return repository.getMovie()
    }

    // MARK: - Core Data stack

    static let shared = DataStorageService()
    private init() {}

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataStorage")
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

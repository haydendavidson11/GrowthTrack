//
//  DataController.swift
//  GrowthTrack
//
//  Created by Hayden Davidson on 12/6/21.
//

import CoreData
import SwiftUI

/// An environment singleton responsible for managing our Core Data stack, including handling saving,
/// counting fetch requests, tracking awards, and dealing with sample data.
class DataController: ObservableObject {
    /// The lone CloudKit container used to store all our data.
    let container: NSPersistentCloudKitContainer

    /// Initializes a data controller either in memory (for temporary use such as testing and previewing),
    /// or on permanent storage (for use in regular app runs.)
    ///
    /// Defaults to permanent storage.
    /// - Parameter inMemory: Whether to store this data in temporary data or not.
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main", managedObjectModel: Self.model)

        // For testing and previewing purposes, we create a temporary,
        // in-memory database by writing to /dev/null so our data is
        // destroyed after the app finishes running.
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Fatal error loading store \(error.localizedDescription)")
            }

            #if DEBUG
            if CommandLine.arguments.contains("enable-testing") {
                self.deleteAll()
                UIView.setAnimationsEnabled(false)
            }
            #endif
        }
    }

    static var preview: DataController = {
        let dataController = DataController(inMemory: true)

        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error creating preview \(error.localizedDescription)")
        }

        return dataController
    }()

    // Creates a single instance of our managed Object Model
    // for use in both test cases, and proper runs of the application.
    static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "Main", withExtension: "momd") else {
            fatalError("Failed to locate model file")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load model file.")
        }
        return managedObjectModel
    }()

    /// Creates example projects and items to make manual testing easier.
    ///  - Throws: An NSError sent from calling save() on the NSManagedObjectContext.
    func createSampleData() throws {
        let viewContext = container.viewContext

        for exampleProject in 1...5 {
            let project = Project(context: viewContext)
            project.title = "Project \(exampleProject)"
            project.items = []
            project.creationDate = Date()
            project.closed = Bool.random()

            for exampleItem in 1...10 {
                let item = Item(context: viewContext)
                item.title = "Item \(exampleItem)"
                item.creationDate = Date()
                item.completed = Bool.random()
                item.project = project
                item.priority = Int16.random(in: 1...3)
            }
        }

        try viewContext.save()
    }

    /// Saves our Core Data context iff there are changes. This silently ignores
    /// any error cause by saving, but this should be fine because our
    /// attributes are optional.
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }

    /// Deletes the desired object from the Core Data context.
    /// - Parameter object: The managed object to be deleted.
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }

    /// Deletes all projects and items from the Core Data context
    func deleteAll() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Item.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchDeleteRequest1)

        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        _ = try? container.viewContext.execute(batchDeleteRequest2)
    }

    /// Count the number of ManagedObjects(T) in the given fetchRequest.
    /// - Returns: the number of items counted for the given fetch Request.
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }

    /// Validates the user has earned the given award.
    /// - Parameter award: The award to be validated.
    /// - Returns: Whether the award has been earned by the user or not.
    func hasEarned(award: Award) -> Bool {
        switch award.criterion {
        case "items":
            // returns true if the user added a certain number of items.
            let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value

        case "complete":
            // returns true if the user completes a certain number of items.
            let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            fetchRequest.predicate = NSPredicate(format: "completed = true")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value

        default:
            // an unknown award criteria; this should never be allowed.
//            fatalError("Unknown award criterion: \(award.criterion)")
            return false
        }
    }
}

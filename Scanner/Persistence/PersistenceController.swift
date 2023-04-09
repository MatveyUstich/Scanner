//
//  PersistenceController.swift
//  Scanner
//
//  Created by Александр Устич on 07.04.2023.
//

import CoreData
import UIKit

class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ScannedDocument")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
    }

    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

}

extension PersistenceController {
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let document1 = ScannedDocument(context: viewContext)
        document1.dateAdded = Date()
        document1.imageData = UIImage(named: "1.3.4-SetHeight_grey")?.pngData()

        let document2 = ScannedDocument(context: viewContext)
        document2.dateAdded = Date()
        document2.imageData = UIImage(named: "2D_ExcessSpace")?.pngData()

        do {
            try viewContext.save()
        } catch {
            fatalError("Error previewing: \(error.localizedDescription)")
        }

        return result
    }()
}


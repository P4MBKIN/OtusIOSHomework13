//
//  PersistenceStack.swift
//  DataStructuresProfiling
//
//  Created by Pavel on 01.06.2020.
//  Copyright © 2020 Exey Panteleev. All rights reserved.
//

import CoreData

class PersistenceStack {

    private let name: String

    private lazy var storeUrl: URL = {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Невозможно получить директорию документов")
        }
        return documentsUrl.appendingPathComponent("\(name).sqlite")
    }()

    private lazy var modelUrl: URL = {
        guard let modelUrl = Bundle.main.url(forResource: name, withExtension: "momd") else {
            fatalError("Невозможно найти файл модели")
        }
        return modelUrl
    }()

    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let model = NSManagedObjectModel(contentsOf: modelUrl) else {
            fatalError("Невозможно открыть файл модели: \(modelUrl)")
        }
        return model
    }()

    private lazy var persistenceStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: storeUrl,
                                               options: nil)
        } catch {
            fatalError("Невозможно сосдать хранилище: \(storeUrl)")
        }
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistenceStoreCoordinator
        context.undoManager = UndoManager()
        return context
    }()

    init(name: String) {
        self.name = name
    }

}

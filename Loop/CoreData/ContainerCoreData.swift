//
//  ContainerCoreData.swift
//  Loop
//
//  Created by Nikita Zaremba on 19.07.2022.
//  Copyright © 2022 LoopKit Authors. All rights reserved.
//

import Foundation
import CoreData

class ContainerCoreData{
    static let shared = ContainerCoreData()
    
    private init(){
        checkContainer()
    }
    
    let persistentContainer: NSPersistentContainer = NSPersistentContainer(name: "Food")
    
    lazy var mainContext = persistentContainer.viewContext
    var backgroundContext: NSManagedObjectContext {
        let background = persistentContainer.newBackgroundContext()
        background.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        background.automaticallyMergesChangesFromParent = true
        background.shouldDeleteInaccessibleFaults = true
       return background
    }
    
    func checkContainer() {
        persistentContainer.loadPersistentStores(completionHandler: {[self] (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }else{
                persistentContainer.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
                persistentContainer.viewContext.shouldDeleteInaccessibleFaults = true
                persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
            }
        })
    }
}

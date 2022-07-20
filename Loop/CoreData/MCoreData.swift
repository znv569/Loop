//
//  MCoreData.swift
//  Loop
//
//  Created by Nikita Zaremba on 19.07.2022.
//  Copyright © 2022 LoopKit Authors. All rights reserved.
//

import Foundation
import CoreData

class MCoreData<T: NSManagedObject> {
    var contextLink: NSManagedObjectContext = ContainerCoreData.shared.backgroundContext
    
    var context: NSManagedObjectContext {
        contextLink
    }
    
    enum PerformMode{
        case sync, async
    }
    
    
    func save(){
        do{
            try context.save()
        }catch let error as NSError {
            fatalError("Ошибка \(error)")
        }
        context.reset()
    }
    
    func delete(object: NSManagedObject, performMode: PerformMode = .async){
        switch performMode {
        case .sync:
            context.delete(object)
            save()
        case .async:
            context.perform { [weak self] in
                self?.context.delete(object)
                self?.save()
            }
        }
    }
    
    private func getObjectsPerform(predicate: NSPredicate? = nil, sort: [NSSortDescriptor]? = nil) -> [T]{
        let fetchRequest = T.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sort
        var list:[T] = []
        do{
            list = try context.fetch(fetchRequest).compactMap({$0 as? T})
        }catch{
            fatalError("Fetching Failed")
        }
        return list
    }
    
    func getObjects(predicate: NSPredicate? = nil, sort: [NSSortDescriptor]? = nil, modePerform: PerformMode = .async, compleation: @escaping ([T])->Void) {
        switch modePerform {
        case .sync:
            context.performAndWait { [weak self] in
                guard let self = self else {return}
                let list = self.getObjectsPerform(predicate: predicate, sort: sort)
                compleation(list)
            }
        case .async:
            context.perform { [weak self] in
                guard let self = self else {return}
                let list = self.getObjectsPerform(predicate: predicate, sort: sort)
                compleation(list)
            }
        }
    }
}

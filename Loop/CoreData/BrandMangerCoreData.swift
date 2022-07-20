//
//  BrandCoreData.swift
//  Loop
//
//  Created by Nikita Zaremba on 19.07.2022.
//  Copyright © 2022 LoopKit Authors. All rights reserved.
//

import Foundation
import CoreData

class BrandMangerCoreData: MCoreData<BrandFoodCoreData> {
    static let shared = BrandMangerCoreData()
    
    override var context: NSManagedObjectContext {
        UnitManagerCoreData.shared.context
    }
    
    private override init() {
    }
    
    func deleteAllData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "BrandFoodCoreData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        context.performAndWait {
            do {
                try ContainerCoreData.shared.persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: self.context)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            self.save()
        }
    }
    
    func findBrands(brand: String, compleation: @escaping (([BrandFoodCoreData])->Void)) {
        
        var predicates = [NSPredicate]()
        
        let names = brand.components(separatedBy: " ")
        
        for name in names {
            let predicate1 = NSPredicate(format: #keyPath(BrandFoodCoreData.name) + " CONTAINS[cd] %@", name)
            let predicate2 = NSPredicate(format: #keyPath(BrandFoodCoreData.name) + " BEGINSWITH[cd] %@", name)
            let predicate3 = NSPredicate(format: #keyPath(BrandFoodCoreData.name) + " LIKE '%@'", name)
            let predicate4 = NSPredicate(format: #keyPath(BrandFoodCoreData.name) + "== %@", name)
            let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [predicate1, predicate2, predicate3, predicate4])
            predicates.append(predicate)
        }
        
        let predicate1 = NSPredicate(format: #keyPath(BrandFoodCoreData.name) + " CONTAINS[cd] %@", brand)
        let predicate2 = NSPredicate(format: #keyPath(BrandFoodCoreData.name) + " BEGINSWITH[cd] %@", brand)
        let predicate3 = NSPredicate(format: #keyPath(BrandFoodCoreData.name) + " LIKE '%@'", brand)
        let predicate4 = NSPredicate(format: #keyPath(BrandFoodCoreData.name) + "== %@", brand)
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [predicate1, predicate2, predicate3, predicate4])
        
        
        let mainPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        let sendPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [mainPredicate, predicate])
        
        
        
        let sortDescriptorIndex = NSSortDescriptor(key: #keyPath(BrandFoodCoreData.index), ascending: true)
        
        let sortDescriptorName = NSSortDescriptor(key: #keyPath(BrandFoodCoreData.name), ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare))
        
        getObjects(predicate: sendPredicate, sort: [sortDescriptorIndex, sortDescriptorName]) { items in
            compleation(items)
        }
    }
    
    func findBrand(brand: String, compleation: @escaping ((BrandFoodCoreData?)->Void)) {
        let predicates: [NSPredicate] = [NSPredicate(format: #keyPath(BrandFoodCoreData.name) + "== %@", brand)]
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        getObjects(predicate: predicate){ items in
            let item = items.first
            compleation(item)
        }
    }
}

//
//  FoodManagerCoreData.swift
//  Loop
//
//  Created by Nikita Zaremba on 19.07.2022.
//  Copyright © 2022 LoopKit Authors. All rights reserved.
//

import Foundation
import CoreData

extension NSString {
    @objc func countCompare(_ string: String) -> ComparisonResult {
        if String(self).count > string.count {
            return .orderedDescending
        }
        if String(self).count < string.count {
            return .orderedAscending
        }
        return .orderedSame
    }
}

class FoodManagerCoreData: MCoreData<FoodCoreData> {
    static let shared = FoodManagerCoreData()
    
    override var context: NSManagedObjectContext {
        UnitManagerCoreData.shared.context
    }
    
    private override init() {
    }
    
    func deleteAllData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FoodCoreData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        context.performAndWait {
            do {
                try ContainerCoreData.shared.persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: self.context)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            self.save()
        }
        BrandMangerCoreData.shared.deleteAllData()
        UnitManagerCoreData.shared.deleteAllData()
    }
    
    func countData() {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UnitCoreData")
        let entity = NSEntityDescription.entity(forEntityName: "UnitCoreData", in: self.context)
        let statusDesc = entity?.attributesByName["name"]

        fetch.propertiesToFetch = [statusDesc].compactMap { $0 }
        fetch.resultType = .dictionaryResultType

        var results: [Any]? = [Any]()
        do {
            results = try self.context.fetch(fetch)
        } catch {
        }
        print(results?.count)
        
    }
    
    func findProduct(name: String, brand: BrandFoodCoreData? = nil, comleation: @escaping ([FoodCoreData]) -> Void) {
        let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if name == "" && brand == nil {
            comleation([])
            return
        }
        var predicates = [NSPredicate]()
        
        var sendPredicates: [NSPredicate] = []
        
        if name.count > 0 {
            let names = name.lowercased().components(separatedBy: " ")
            for name in names {
                let predicate1 = NSPredicate(format: #keyPath(FoodCoreData.tags) + " CONTAINS[cd] %@", name)
                let predicate2 = NSPredicate(format: #keyPath(FoodCoreData.tags) + " BEGINSWITH[cd] %@", name)
                let predicate3 = NSPredicate(format: #keyPath(FoodCoreData.tags) + " LIKE '%@'", name)
                let predicate4 = NSPredicate(format: #keyPath(FoodCoreData.tags) + "== %@", name)
                let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [predicate1, predicate2, predicate3, predicate4])
                predicates.append(predicate)
            }
            
            let predicate1 = NSPredicate(format: #keyPath(FoodCoreData.name) + " CONTAINS[cd] %@", name)
            let predicate2 = NSPredicate(format: #keyPath(FoodCoreData.name) + " BEGINSWITH[cd] %@", name)
            let predicate3 = NSPredicate(format: #keyPath(FoodCoreData.name) + " LIKE '%@'", name)
            let predicate4 = NSPredicate(format: #keyPath(FoodCoreData.name) + "== %@", name)
            let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [predicate1, predicate2, predicate3, predicate4])
            
            
            let mainPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            let sendPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [mainPredicate, predicate])
            sendPredicates.append(sendPredicate)
        }
        
        if let brand = brand {
            let predicateWithBrand = NSPredicate(format: #keyPath(FoodCoreData.brand) + "  == %@", brand)
            sendPredicates.append(predicateWithBrand)
        }
        
        
        let predicateComWithBrand = NSCompoundPredicate(andPredicateWithSubpredicates: sendPredicates)
        
        var sortDescriptionAr = [NSSortDescriptor]()
        if name.count > 0 {
            sortDescriptionAr.append(NSSortDescriptor(key: #keyPath(FoodCoreData.count), ascending: true))
            sortDescriptionAr.append(NSSortDescriptor(key: #keyPath(FoodCoreData.brand.index), ascending: true))
            sortDescriptionAr.append(NSSortDescriptor(key: #keyPath(FoodCoreData.brand.name), ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare)))
        } else {
            sortDescriptionAr.append(NSSortDescriptor(key: #keyPath(FoodCoreData.name), ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare)))
        }

        
        getObjects(predicate: predicateComWithBrand, sort: sortDescriptionAr, modePerform: .async) { models in
            comleation(models)
        }
    }
    
    func addData(models: [FoodProduct], compleation: @escaping ((Double) -> Void)) {
        context.perform {
            self.countData()
            
            let count = models.count
            var brands: [String: BrandFoodCoreData] = [:]
            
            for (index, model) in models.enumerated() {
                let brandCore: BrandFoodCoreData
                if let brand = brands[model.brand.trimmingCharacters(in: .whitespacesAndNewlines)] {
                    brandCore = brand
                } else {
                    brandCore = BrandFoodCoreData(context: self.context)
                    brandCore.name = model.brand.trimmingCharacters(in: .whitespacesAndNewlines)
                    brandCore.index = (model.brand == "Общая категория") ? 0 : 1
                    brands[model.brand.trimmingCharacters(in: .whitespacesAndNewlines)] = brandCore
                }
                
                var units = [UnitCoreData]()
                for unit in model.units {
                    let unitCore = UnitCoreData(context: self.context)
                    unitCore.cal = unit.kkal
                    unitCore.carb = unit.carb
                    unitCore.protein = unit.protein
                    unitCore.fat = unit.fat
                    unitCore.name = unit.name.trimmingCharacters(in: .whitespacesAndNewlines)
                    units.append(unitCore)
                }
                let foodCore = FoodCoreData(context: self.context)
                foodCore.units = NSOrderedSet(array: units)
                foodCore.brand = brandCore
                foodCore.tags = model.tags.trimmingCharacters(in: .whitespacesAndNewlines)
                foodCore.count = Int16(model.title.count)
                foodCore.name = model.title.trimmingCharacters(in: .whitespacesAndNewlines)
                compleation(Double(index) / Double(count))
            }
            
            self.save()
            compleation(0)
            
            self.countData()
        }
    }
}

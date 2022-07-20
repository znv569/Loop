//
//  UnitManagerCoreData.swift
//  Loop
//
//  Created by Nikita Zaremba on 19.07.2022.
//  Copyright © 2022 LoopKit Authors. All rights reserved.
//

import Foundation
import CoreData

class UnitManagerCoreData: MCoreData<UnitCoreData> {
    static let shared = UnitManagerCoreData()
    
    private override init() {
    }
    
    func deleteAllData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "UnitCoreData")
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
    
}

//
//  CoreDataManager.swift
//  BikeShowcase
//
//  Created by Vishal on 25/12/17.
//  Copyright © 2017 Vishal. All rights reserved.
//

import UIKit
import CoreData


struct bItem {
    var name:String?
    var cname:String?
    var bid:String?
    
    init() {
        name = ""
        cname = ""
        bid = ""
    }
    init(bid:String,cname:String,name:String) {
        self.name = name
        self.cname = cname
        self.bid = bid
    }
}

class CoreDataManager: NSObject {
    
    static let sharedInstanceCD = CoreDataManager()
    
    private class func getContext() -> NSManagedObjectContext {
        
        return sharedInstanceCD.persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "BikeShowcase")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK: store obj into core data
    class func storeObj(bid:String,cname:String,name:String) {
        let context = getContext()
        
        
        
        //check if the bike id record is already present and then insert
        
        let predicate = NSPredicate(format: "bid == %@", bid)
        let fetchRequest:NSFetchRequest<BEntity> = BEntity.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        do {
        let count = try context.fetch(fetchRequest)
            if(count.count == 0){
                
                let entity = NSEntityDescription.entity(forEntityName: "BEntity", in: context)
                
                let managedObj = NSManagedObject(entity: entity!, insertInto: context)
                
                managedObj.setValue(bid, forKey: "bid")
                managedObj.setValue(cname, forKey: "cname")
                managedObj.setValue(name, forKey: "name")
                
                do {
                    try context.save()
                    print("saved!")
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        }catch {
            print(error.localizedDescription)
        }
        
        
        
    }
    
    //MARK: fetch all the objects from core data
    class func fetchObj(selectedScopeIdx:Int?=nil,targetText:String?=nil) -> [bItem]{
        var aray = [bItem]()
        
        let fetchRequest:NSFetchRequest<BEntity> = BEntity.fetchRequest()
        
        if selectedScopeIdx != nil && targetText != nil{
            
            var filterKeyword = ""
            switch selectedScopeIdx! {
            case 0:
                filterKeyword = "name"
            case 1:
                filterKeyword = "cname"
            default:
                filterKeyword = "name"
            }
            
            let predicate = NSPredicate(format: "\(filterKeyword) contains[c] %@", targetText!)

            
            fetchRequest.predicate = predicate
        }
        
        do {
            let managedObjectContext = sharedInstanceCD.persistentContainer.newBackgroundContext()
            let fetchResult = try managedObjectContext.fetch(fetchRequest)
            
            for item in fetchResult {
                
                let bidd = item.bid != nil ? item.bid! : "No bike ID"
                let cnamee = item.cname != nil ? item.cname! : "No company name"
                let namee = item.name != nil ? item.name! : "No bike name"
                
                let val = bItem(bid: bidd, cname: cnamee, name: namee)
                aray.append(val)
                
            }
        }catch {
            print(error.localizedDescription)
        }
        
        return aray
    }
    
    //MARK: delete all the data in core data
    class func cleanCoreData() {
        
        let fetchRequest:NSFetchRequest<BEntity> = BEntity.fetchRequest()
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            print("deleting all contents")
            let managedObjectContext = sharedInstanceCD.persistentContainer.newBackgroundContext()
            try managedObjectContext.execute(deleteRequest)
        }catch {
            print(error.localizedDescription)
        }
        
    }

}

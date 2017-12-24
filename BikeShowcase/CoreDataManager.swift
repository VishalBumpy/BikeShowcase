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
    
    private class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    ///store obj into core data
    class func storeObj(bid:String,cname:String,name:String) {
        let context = getContext()
        
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
    
    ///fetch all the objects from core data
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
            let fetchResult = try getContext().fetch(fetchRequest)
            
            for item in fetchResult {
                let val = bItem(bid: item.bid!, cname: item.cname!, name: item.name!)
                aray.append(val)
                
            }
        }catch {
            print(error.localizedDescription)
        }
        
        return aray
    }
    
    ///delete all the data in core data
    class func cleanCoreData() {
        
        let fetchRequest:NSFetchRequest<BEntity> = BEntity.fetchRequest()
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            print("deleting all contents")
            try getContext().execute(deleteRequest)
        }catch {
            print(error.localizedDescription)
        }
        
    }

}

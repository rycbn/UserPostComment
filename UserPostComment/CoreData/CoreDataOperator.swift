//
//  CoreDataOperator.swift
//  UserPostComment
//
//  Created by Roger Yong on 05/04/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import CoreData

class CoreDataOperation  {
    
    class func objectCountForEntity (entityName:String, context:NSManagedObjectContext) -> Int {        
        let request = NSFetchRequest(entityName: entityName)
        var error:NSError?
        let count = context.countForFetchRequest(request, error: &error)
        if let _error = error {
            print("\(#function) Error: \(_error.localizedDescription)")
        } else {
            //print("There are \(count) \(entityName) object(s) in \(context)")
        }
        return count
    }
    class func objectsForEntity(entityName:String, context:NSManagedObjectContext, filter:NSPredicate?, sort:[NSSortDescriptor]?) -> [AnyObject]? {
        let request = NSFetchRequest(entityName:entityName)
        request.predicate = filter
        request.sortDescriptors = sort
        do {
            return try context.executeFetchRequest(request)
        } catch {
            print("\(#function) FAILED to fetch objects for \(entityName) entity")
            return nil
        }
    }
    class func objectName(object:NSManagedObject) -> String {
        if let name = object.valueForKey("name") as? String {
            return name
        }
        return object.description
    }
    class func objectDeletionIsValid(object:NSManagedObject) -> Bool {
        do {
            try object.validateForDelete()
            return true // object can be deleted
        } catch let error as NSError {
            print("'\(objectName(object))' can't be deleted. \(error.localizedDescription)")
            return false // object can't be deleted
        }
    }
    class func objectBatchDeletion(entityName: String, context:NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.executeRequest(deleteRequest)
        }
        catch {
            print("\(#function) FAILED to delete objects for \(entityName) entity")
        }
    }
}

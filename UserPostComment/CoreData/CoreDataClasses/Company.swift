//
//  Company.swift
//  UserPostComment
//
//  Created by Roger Yong on 05/04/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import Foundation
import CoreData

class Company: NSManagedObject {
    // MARK:- INSERT
    /*class func insert(company: [String: AnyObject]) {
        let entity = NSEntityDescription.entityForName(EntityName.Company, inManagedObjectContext: context())
        let item = Company(entity: entity!, insertIntoManagedObjectContext: context)
        item.name = company[JsonResponseKeys.Name] as? String
        item.catchPhrase = company[JsonResponseKeys.CatchPhrase] as? String
        item.bs = company[JsonResponseKeys.Bs] as? String
        appDelegate().coreDataStack.saveContext()
    }*/
}

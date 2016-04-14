//
//  Address.swift
//  UserPostComment
//
//  Created by Roger Yong on 05/04/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import Foundation
import CoreData

class Address: NSManagedObject {
    // MARK:- INSERT
    /*class func insert(address: [String: AnyObject]) {
        let entity = NSEntityDescription.entityForName(EntityName.Address, inManagedObjectContext: objContext())
        let item = Address(entity: entity!, insertIntoManagedObjectContext: context)
        item.street = address[JsonResponseKeys.Street] as? String
        item.suite = address[JsonResponseKeys.Suite] as? String
        item.city = address[JsonResponseKeys.City] as? String
        item.zipcode = address[JsonResponseKeys.ZipCode] as? String
        let geo = address[JsonResponseKeys.Geo] as? [String: AnyObject]
        Geo.insert(geo!)
        objSaveContext()
    }*/
}

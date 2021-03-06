//
//  User.swift
//  UserPostComment
//
//  Created by Roger Yong on 05/04/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {
    // MARK: GET
    class func getUserInfo(userId: Int) -> User {
        var item: User!
        let predicate = NSPredicate(format: "id = %li", userId)
        let items = CoreDataOperation.objectsForEntity(EntityName.User, context: objContext(), filter: predicate, sort: nil) as! [User]
        item = items[0]
        return item
    }
    // MARK:- INSERT
    class func insert(users: [AnyObject]) {
        if let entityUser = NSEntityDescription.entityForName(EntityName.User, inManagedObjectContext: objContext()),
            let entityAddress = NSEntityDescription.entityForName(EntityName.Address, inManagedObjectContext: objContext()),
            let entityCompany = NSEntityDescription.entityForName(EntityName.Company, inManagedObjectContext: objContext()),
            let entityGeo = NSEntityDescription.entityForName(EntityName.Geo, inManagedObjectContext: objContext()) {
            for user in users {
                let item = User(entity: entityUser, insertIntoManagedObjectContext: objContext())
                let address = Address(entity: entityAddress, insertIntoManagedObjectContext: objContext())
                let company = Company(entity: entityCompany, insertIntoManagedObjectContext: objContext())
                let geo = Geo(entity: entityGeo, insertIntoManagedObjectContext: objContext())

                
                if let adds = user[JsonResponseKeys.Address] as? [String: AnyObject],
                    let geoLoc = adds[JsonResponseKeys.Geo] as? [String: AnyObject],
                    let comp = user[JsonResponseKeys.Company] as? [String: AnyObject] {

                    // Address
                    address.street = adds[JsonResponseKeys.Street] as? String
                    address.suite = adds[JsonResponseKeys.Suite] as? String
                    address.city = adds[JsonResponseKeys.City] as? String
                    address.zipcode = adds[JsonResponseKeys.ZipCode] as? String
                    
                    // Geo
                    geo.latitude = geoLoc[JsonResponseKeys.Lat] as? String
                    geo.longitude = geoLoc[JsonResponseKeys.Lng] as? String
                    address.geo = geo
                    
                    // Company
                    company.name = comp[JsonResponseKeys.Name] as? String
                    company.catchPhrase = comp[JsonResponseKeys.CatchPhrase] as? String
                    company.bs = comp[JsonResponseKeys.Bs] as? String
                }
                // User
                item.id = user[JsonResponseKeys.Id] as? NSNumber
                item.name = user[JsonResponseKeys.Name] as? String
                item.username = user[JsonResponseKeys.Username] as? String
                item.email = user[JsonResponseKeys.Email] as? String
                item.phone = user[JsonResponseKeys.Phone] as? String
                item.website = user[JsonResponseKeys.Website] as? String
                item.address = address
                item.company = company
            }
            objSaveContext()
        }
    }
}

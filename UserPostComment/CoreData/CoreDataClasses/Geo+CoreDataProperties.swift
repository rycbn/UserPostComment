//
//  Geo+CoreDataProperties.swift
//  UserPostComment
//
//  Created by Roger Yong on 05/04/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Geo {

    @NSManaged var latitude: String?
    @NSManaged var longitude: String?
    @NSManaged var coordinate: Address?

}

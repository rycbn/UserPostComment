//
//  Post+CoreDataProperties.swift
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

extension Post {

    @NSManaged var userId: NSNumber?
    @NSManaged var id: NSNumber?
    @NSManaged var title: String?
    @NSManaged var body: String?

}

//
//  Post.swift
//  UserPostComment
//
//  Created by Roger Yong on 05/04/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import Foundation
import CoreData

class Post: NSManagedObject {
    // MARK:- GET
    class func getPostInfo() -> [Post] {
        let items = CoreDataOperation.objectsForEntity(EntityName.Post, context: objContext(), filter: nil, sort: nil) as! [Post]
        return items
    }
    // MARK:- INSERT
    class func insert(posts: [AnyObject]){
        let entity = NSEntityDescription.entityForName(EntityName.Post, inManagedObjectContext: objContext())
        for post in posts {
            let item = Post(entity: entity!, insertIntoManagedObjectContext: objContext())
            item.id = post[JsonResponseKeys.Id] as? NSNumber
            item.userId = post[JsonResponseKeys.UserId] as? NSNumber
            item.title = post[JsonResponseKeys.Title] as? String
            item.body = post[JsonResponseKeys.Body] as? String
        }
        objSaveContext()
    }
}

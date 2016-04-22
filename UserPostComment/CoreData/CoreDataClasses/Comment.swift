//
//  Comment.swift
//  UserPostComment
//
//  Created by Roger Yong on 05/04/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import Foundation
import CoreData

class Comment: NSManagedObject {
    // MARK: GET
    class func getCommentInfo(postId: Int) -> [Comment] {
        let predicate = NSPredicate(format: "postId = %li", postId)
        let items = CoreDataOperation.objectsForEntity(EntityName.Comment, context: objContext(), filter: predicate, sort: nil) as! [Comment]
        return items
    }
    // MARK:- INSERT
    class func insert(comments: [AnyObject]) {
        if let entity = NSEntityDescription.entityForName(EntityName.Comment, inManagedObjectContext: objContext()) {
            for comment in comments {
                let item = Comment(entity: entity, insertIntoManagedObjectContext: objContext())
                item.id = comment[JsonResponseKeys.Id] as? NSNumber
                item.postId = comment[JsonResponseKeys.PostId] as? NSNumber
                item.name = comment[JsonResponseKeys.Name] as? String
                item.email = comment[JsonResponseKeys.Email] as? String
                item.body = comment[JsonResponseKeys.Body] as? String
            }
            objSaveContext()
            NSNotificationCenter.defaultCenter().postNotificationName(Notification.InsertCompleted, object: self)
        }
    }
}

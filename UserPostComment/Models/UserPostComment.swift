//
//  UserPostComment.swift
//  UserPostComment
//
//  Created by Roger Yong on 06/04/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import UIKit

protocol UserPostCommentDelegate {
    func apiError()
}

class UserPostComment: NSObject {
    
    var delegate: UserPostCommentDelegate!
    
    func getUserFromApi() {
        TaskConfig().getUserData({ (results, error) in
            if let results = results {
                User.insert(results)
                self.getPostFromApi()
            }
            else {
                self.delegate.apiError()
            }
        })
    }
    func getPostFromApi() {
        TaskConfig().getPostData({ (results, error) in
            if let results = results {
                Post.insert(results)
                self.getCommentFromApi()
            }
            else {
                self.delegate.apiError()
            }
        })
    }
    func getCommentFromApi() {
        TaskConfig().getCommentData({ (results, error) in
            if let results = results {
                Comment.insert(results)
            }
            else {
                self.delegate.apiError()
            }
        })
    }
}

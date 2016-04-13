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
            if results == nil {
                self.delegate.apiError()
            }
            else {
                User.insert(results!)
                self.getPostFromApi()
            }
        })
    }
    func getPostFromApi() {
        TaskConfig().getPostData({ (results, error) in
            if results == nil {
                self.delegate.apiError()
            }
            else {
                Post.insert(results!)
                self.getCommentFromApi()
            }
        })
    }
    func getCommentFromApi() {
        TaskConfig().getCommentData({ (results, error) in
            if results == nil {
                self.delegate.apiError()
            }
            else {
                Comment.insert(results!)
            }
        })
    }
}

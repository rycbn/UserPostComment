//
//  PostList.swift
//  UserPostComment
//
//  Created by Roger Yong on 06/04/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import UIKit

protocol PostListDelegate {
    func postData(data: [PostList])
}

class PostList: NSObject {
    var delegate: PostListDelegate!
    var id: NSNumber!
    var userId: NSNumber!
    var username: String!
    var title: String!
    var body: String!
    var imageUrl: String!
    
    func getPostData() {
        var lists = [PostList]()
        let items = Post.getPostInfo()
        for item in items {
            let list = PostList()
            list.id = item.id
            list.userId = item.userId
            list.username = User.getUserInfo(Int(list.userId)).username
            list.title = item.title
            list.body = item.body
            list.imageUrl = String(format: "https://api.adorable.io/avatars/40/%@@adorable.png", list.username)
            lists.append(list)
        }
        lists.sortInPlace({ $0.title < $1.title })
        dispatch_async(dispatch_get_main_queue(), {
            self.delegate!.postData(lists)
        })
    }
}
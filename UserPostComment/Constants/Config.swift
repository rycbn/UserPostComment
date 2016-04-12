//
//  Config.swift
//  UserPostComment
//
//  Created by Roger Yong on 05/04/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import UIKit

struct Client {
    static let Name = "UserPostComment"
}

struct ApiUrl {
    static let Base = "http://jsonplaceholder.typicode.com/"
}

struct Methods {
    static let Users = "users"
    static let Posts = "posts"
    static let Comments = "comments"
}

struct EntityName {
    static let Address = "Address"
    static let Comment = "Comment"
    static let Company = "Company"
    static let User = "User"
    static let Geo = "Geo"
    static let Post = "Post"
}

struct JsonDefaultFile {
    static let User = NSBundle.mainBundle().pathForResource("user", ofType: "json")
    static let Post = NSBundle.mainBundle().pathForResource("post", ofType: "json")
    static let Comment = NSBundle.mainBundle().pathForResource("comment", ofType: "json")
}

struct JsonResponseKeys {
    static let Id = "id"
    static let Name = "name"
    static let Username = "username"
    static let Email = "email"
    static let Address = "address"
    static let Street = "street"
    static let Suite = "suite"
    static let City = "city"
    static let ZipCode = "zipcode"
    static let Geo = "geo"
    static let Lat = "lat"
    static let Lng = "lng"
    static let Phone = "phone"
    static let Website = "website"
    static let Company = "company"
    static let CatchPhrase = "catchPhrase"
    static let Bs = "bs"
    static let PostId = "postId"
    static let Body = "body"
    static let UserId = "userId"
    static let Title = "title"
}
struct JsonErrorKey {
    static let Error = "Error"
}
struct JsonErrorValue {
    static let Error = "Error"
    static let BadRequest = "BadRequest"
    static let Unauthorized = "Unauthorized"
    static let NoData = "NoData"
    static let AuthorizationDenied = "Authorization has been denied for this request."
}
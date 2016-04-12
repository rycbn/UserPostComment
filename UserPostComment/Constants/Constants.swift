//
//  Constants.swift
//  UserPostComment
//
//  Created by Roger Yong on 05/04/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import UIKit

struct Identifier {
    struct Storyboard {
        static let Main = "Main"
        static let Post = "PostStorybordId"
        static let PostDetail = "PostDetailStoryboardId"
        static let User = "UserStoryboardId"
        static let Comment = "CommentStoryboardId"
    }
    struct TableView {
        static let Cell = "Cell"
    }
    struct MapView {
        static let Annotation = "Annotation"
    }
}

struct Selectors {
    static let GoBack = "goBack"
    static let NativeBounds = "nativeBounds"
    static let GotoUserInfo = "gotoUserInfo:"
    static let GotoComments = "gotoComments:"
    static let Dismiss = "dismiss:"
    
    struct ReceivedNotification {
        static let Post = "receivedNotificationPost:"
    }
}

struct Notification {
    static let InsertCompleted = "InsertCompleted"
}
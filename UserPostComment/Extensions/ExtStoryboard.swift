//
//  ExtStoryboard.swift
//  UserPostComment
//
//  Created by Roger Yong on 05/04/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import UIKit

internal extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: Identifier.Storyboard.Main, bundle: NSBundle.mainBundle())
    }
    class func postViewController() -> PostViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier(Identifier.Storyboard.Post) as? PostViewController
    }
    class func postDetailViewController() -> PostDetailViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier(Identifier.Storyboard.PostDetail) as? PostDetailViewController
    }
    class func userViewController() -> UserViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier(Identifier.Storyboard.User) as? UserViewController
    }
    class func commentViewController() -> CommentViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier(Identifier.Storyboard.Comment) as? CommentViewController
    }
}

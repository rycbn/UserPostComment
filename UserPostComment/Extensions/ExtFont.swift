//
//  ExtFont.swift
//  UserPostComment
//
//  Created by Roger Yong on 07/04/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import UIKit

extension UIFont {
    func sizeOfString(string: NSString, constrainedToWidth width: CGFloat) -> CGSize {
        return string.boundingRectWithSize(CGSizeMake(width, CGFloat.max),
                                           options: .UsesLineFragmentOrigin,
                                           attributes: [NSFontAttributeName: self],
                                           context: nil).size
    }
    func sizeOfString(string: NSString, constrainedToWidth width: CGFloat, attributes: [String : AnyObject]) -> CGSize {
        return string.boundingRectWithSize(CGSizeMake(width, CGFloat.max),
                                           options: .UsesLineFragmentOrigin,
                                           attributes: attributes,
                                           context: nil).size
    }
}
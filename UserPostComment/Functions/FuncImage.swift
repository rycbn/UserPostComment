//
//  FuncImage.swift
//  UserPostComment
//
//  Created by Roger Yong on 05/04/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import UIKit

func messageImage() -> UIImage? {
    if let image = UIImage(named: ImageName.Message)?.imageWithRenderingMode(.AlwaysTemplate) {
        return image
    }
    return nil
}
func backImage() -> UIImage? {
    if let image = UIImage(named: ImageName.Back)?.imageWithRenderingMode(.AlwaysTemplate) {
        return image
    }
    return nil
}
func closeImage() -> UIImage? {
    if let image = UIImage(named: ImageName.Close)?.imageWithRenderingMode(.AlwaysTemplate) {
        return image
    }
    return nil
}
func userImage() -> UIImage? {
    if let image = UIImage(named: ImageName.User)?.imageWithRenderingMode(.AlwaysTemplate) {
        return image
    }
    return nil
}
func phoneImage() -> UIImage? {
    if let image = UIImage(named: ImageName.Phone)?.imageWithRenderingMode(.AlwaysTemplate) {
        return image
    }
    return nil
}
func emailImage() -> UIImage? {
    if let image = UIImage(named: ImageName.Email)?.imageWithRenderingMode(.AlwaysTemplate) {
        return image
    }
    return nil
}
func websiteImage() -> UIImage? {
    if let image = UIImage(named: ImageName.Website)?.imageWithRenderingMode(.AlwaysTemplate) {
        return image
    }
    return nil
}
func imageTransition() -> CATransition {
    let transition = CATransition()
    transition.duration = 1.0
    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    transition.type = kCATransitionFade
    return transition
}
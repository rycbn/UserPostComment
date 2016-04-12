//
//  FuncImage.swift
//  UserPostComment
//
//  Created by Roger Yong on 05/04/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import UIKit

func messageImage() -> UIImage {
    let image = UIImage(named: ImageName.Message)!.imageWithRenderingMode(.AlwaysTemplate)
    return image
}
func backImage() -> UIImage {
    let image = UIImage(named: ImageName.Back)!.imageWithRenderingMode(.AlwaysTemplate)
    return image
}
func closeImage() -> UIImage {
    let image = UIImage(named: ImageName.Close)!.imageWithRenderingMode(.AlwaysTemplate)
    return image
}
func userImage() -> UIImage {
    let image = UIImage(named: ImageName.User)!.imageWithRenderingMode(.AlwaysTemplate)
    return image
}
func phoneImage() -> UIImage {
    let image = UIImage(named: ImageName.Phone)!.imageWithRenderingMode(.AlwaysTemplate)
    return image
}
func emailImage() -> UIImage {
    let image = UIImage(named: ImageName.Email)!.imageWithRenderingMode(.AlwaysTemplate)
    return image
}
func websiteImage() -> UIImage {
    let image = UIImage(named: ImageName.Website)!.imageWithRenderingMode(.AlwaysTemplate)
    return image
}

//
//  Device.swift
//  UserPostComment
//
//  Created by Roger Yong on 06/04/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import UIKit

struct Device {
    static let NativeScale: CGFloat         = UIScreen.mainScreen().nativeScale
    static let NativeBoundsHeight: CGFloat  = UIScreen.mainScreen().nativeBounds.size.height
    static let NativeBoundsSelector         = UIScreen.mainScreen().respondsToSelector(Selector(Selectors.NativeBounds))
    static let NaturalScale: CGFloat        = UIScreen.mainScreen().scale
    static let NaturalBoundsHeight: CGFloat = UIScreen.mainScreen().bounds.size.height
    static let NaturalBoundsWidth: CGFloat  = UIScreen.mainScreen().bounds.size.width
    static let Width: CGFloat               = UIScreen.mainScreen().bounds.size.width
    static let Height: CGFloat              = UIScreen.mainScreen().bounds.size.height
    static let Phone6PlusHeight: CGFloat    = 736
    static let Phone6Height: CGFloat        = 667
    static let Phone5Height: CGFloat        = 568
    static let Phone4Height: CGFloat        = 480
    static let Pad2Height: CGFloat          = 1024
    static let PadAirHeight: CGFloat        = 2048
    static let PadRetinaHeight: CGFloat     = 2048
    static let Phone6PlusWidth: CGFloat     = 414
    static let Phone                        = UIDevice.currentDevice().userInterfaceIdiom == .Phone
    static let Pad                          = UIDevice.currentDevice().userInterfaceIdiom == .Pad
    static let Phone4_And_Older_iOS7        = Phone && Height < Phone5Height
    static let Phone5_iOS7                  = Phone && Height == Phone5Height
    static let Phone6_iOS7                  = Phone && Height == Phone6Height
    static let Phone6Plus_iOS7              = Phone && Height == Phone6PlusHeight
    static let Phone4_And_Older_iOS8        = Phone && (NativeBoundsHeight / NativeScale) < Phone5Height
    static let Phone5_iOS8                  = Phone && (NativeBoundsHeight / NativeScale) == Phone5Height
    static let Phone6_iOS8                  = Phone && (NativeBoundsHeight / NativeScale) == Phone6Height
    static let Phone6Plus_iOS8              = Phone && (NativeBoundsHeight / NativeScale) == Phone6PlusHeight
    static let Device_LessThan_iOS8         = (UIDevice.currentDevice().systemVersion as NSString).floatValue < 8
    static let Device_iOS8_Or_Later         = (UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8
    static let Device_iOS9_Or_Later         = (UIDevice.currentDevice().systemVersion as NSString).floatValue >= 9
    static let Phone4                       = NativeBoundsSelector ? Phone4_And_Older_iOS8 : Phone4_And_Older_iOS7
    static let Phone5                       = NativeBoundsSelector ? Phone5_iOS8 : Phone5_iOS7
    static let Phone6                       = NativeBoundsSelector ? Phone6_iOS8 : Phone6_iOS7
    static let Phone6Plus                   = NativeBoundsSelector ? Phone6Plus_iOS8 : Phone6Plus_iOS7
    static let Phone6Zoomed                 = Phone && max(Height, Width) == Phone5Height && Device_iOS8_Or_Later && NativeScale > NaturalScale
    static let Phone6PlusZoomed             = Phone && max(Height, Width) == Phone6Height && Device_iOS8_Or_Later && NativeScale < NaturalScale
}

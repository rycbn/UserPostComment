//
//  FuncBarButton.swift
//  UserPostComment
//
//  Created by Roger Yong on 05/04/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import UIKit

func backBarButtonItem(target viewController: UIViewController) -> UIBarButtonItem {
    let barButtonItem = UIBarButtonItem(image: backImage(), style: .Plain, target: viewController, action: Selector(Selectors.GoBack))
    return barButtonItem
}
//
//  CustomSpinner.swift
//  UserPostComment
//
//  Created by Roger Yong on 04/04/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import UIKit

class CustomSpinner: NSObject {
    var blurView: UIView!
    var indicator: UIActivityIndicatorView!
    var centerBoxView: UIView!
    
    func runSpinnerWithIndicator(view: UIView)  {
        blurView = UIView()
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.backgroundColor = UIColor.colorFromHexRGB(Color.SlateGray)
        blurView.alpha = 0.50
        view.addSubview(blurView)
        
        blurView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        blurView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
        blurView.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
        blurView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        
        centerBoxView = UIView()
        centerBoxView.translatesAutoresizingMaskIntoConstraints = false
        centerBoxView.backgroundColor = UIColor.colorFromHexRGB(Color.LightGray)
        centerBoxView.layer.borderColor = UIColor.colorFromHexRGB(Color.LightGray).CGColor
        centerBoxView.layer.borderWidth = 1.0
        centerBoxView.layer.cornerRadius = 5.0
        view.addSubview(centerBoxView)
        
        centerBoxView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        centerBoxView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        centerBoxView.widthAnchor.constraintEqualToConstant(80).active = true
        centerBoxView.heightAnchor.constraintEqualToConstant(80).active = true
        
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = UIColor.colorFromHexRGB(Color.SlateGray)
        centerBoxView.addSubview(indicator)
        
        indicator.centerXAnchor.constraintEqualToAnchor(centerBoxView.centerXAnchor).active = true
        indicator.centerYAnchor.constraintEqualToAnchor(centerBoxView.centerYAnchor).active = true
        indicator.widthAnchor.constraintEqualToConstant(indicator.frame.width).active = true
        indicator.heightAnchor.constraintEqualToConstant(indicator.frame.height).active = true
    }
    func start() {
        indicator.startAnimating()
    }
    func stop() {
        indicator.stopAnimating()
        CFRunLoopStop(CFRunLoopGetCurrent())
        blurView.removeFromSuperview()
        centerBoxView.removeFromSuperview()
        indicator.removeFromSuperview()
    }
}

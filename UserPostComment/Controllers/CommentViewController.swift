//
//  CommentViewController.swift
//  UserPostComment
//
//  Created by Roger Yong on 07/04/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import UIKit

protocol CommentViewControllerDelegate {
    func removeBackgroundView()
}

class CommentViewController: UIViewController {
    // MARK:- Properties
    var delegate: CommentViewControllerDelegate!
    var tableData: [Comment]!
    var topView: UIView!
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTopView()
        configureTableView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
// MARK:- UI Configuration
extension CommentViewController {
    func configureTopView() {
        topView = UIView()
        topView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topView)
        
        topView.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor).active = true
        topView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        topView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
        topView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        topView.heightAnchor.constraintEqualToConstant(35).active = true
        
        let dismissButton = UIButton(type: .Custom)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.setImage(closeImage(), forState: .Normal)
        dismissButton.setImage(closeImage(), forState: .Highlighted)
        dismissButton.addTarget(self, action: Selector(Selectors.Dismiss), forControlEvents: .TouchUpInside)
        dismissButton.contentHorizontalAlignment = .Right
        topView.addSubview(dismissButton)
        
        topView.trailingAnchor.constraintEqualToAnchor(dismissButton.trailingAnchor, constant: 3).active = true
        dismissButton.heightAnchor.constraintEqualToConstant(closeImage().size.height).active = true
        dismissButton.widthAnchor.constraintEqualToAnchor(dismissButton.heightAnchor, multiplier: 2).active = true
        dismissButton.centerYAnchor.constraintEqualToAnchor(topView.centerYAnchor).active = true
    
        let commentLabel = UILabel()
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.text = tableData.count > 1 ? "COMMENTS" : "COMMENT"
        commentLabel.textColor = UIColor.colorFromHexRGB(Color.SlateGray)
        commentLabel.font = UIFont.systemFontOfSize(16, weight: UIFontWeightSemibold)
        topView.addSubview(commentLabel)
        
        commentLabel.leadingAnchor.constraintEqualToAnchor(topView.leadingAnchor, constant: 16).active = true
        commentLabel.heightAnchor.constraintEqualToAnchor(dismissButton.heightAnchor).active = true
        commentLabel.centerYAnchor.constraintEqualToAnchor(topView.centerYAnchor).active = true
        
        let underline = UILabel()
        underline.translatesAutoresizingMaskIntoConstraints = false
        underline.backgroundColor = UIColor.lightGrayColor()
        topView.addSubview(underline)
        
        topView.bottomAnchor.constraintEqualToAnchor(underline.bottomAnchor, constant: 0.5).active = true
        underline.widthAnchor.constraintEqualToAnchor(topView.widthAnchor).active = true
        underline.heightAnchor.constraintEqualToConstant(0.5).active = true
    }
    func configureTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.exclusiveTouch = true
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:Identifier.TableView.Cell)
        view.addSubview(tableView)
        
        tableView.topAnchor.constraintEqualToAnchor(topView.bottomAnchor).active = true
        tableView.leadingAnchor.constraintEqualToAnchor(super.view.leadingAnchor).active = true
        super.view.trailingAnchor.constraintEqualToAnchor(tableView.trailingAnchor).active = true
        bottomLayoutGuide.topAnchor.constraintEqualToAnchor(tableView.bottomAnchor).active = true
    }
}
// MARK:- Internal Action
extension CommentViewController {
    func dismiss(sender: UIButton) {
        delegate.removeBackgroundView()
        dismissViewControllerAnimated(true, completion: nil)
    }
}
// MARK:- UITableViewDataSource
extension CommentViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: Identifier.TableView.Cell)
        cell.imageView?.image = userImage()
        cell.imageView?.tintColor = UIColor.colorFromHexRGB(Color.SlateGray)
        if isNetworkOrCellularCoverageReachable() {
            let list = tableData[indexPath.row]
            if let email = list.email {
                let username = email.componentsSeparatedByString("@").first
                let imageUrl = String(format: "https://api.adorable.io/avatars/40/%@@adorable.png", username!)
                if isNetworkOrCellularCoverageReachable() {
                    TaskConfig().taskForGETImage(imageUrl, completionHandler: { (imageData, error) in
                        if let image = UIImage(data: imageData!) {
                            dispatch_async(dispatch_get_main_queue(), {
                                cell.imageView?.image = image
                                cell.imageView?.layer.addAnimation(imageTransition(), forKey: nil)
                            })
                        }
                    })
                }
            }
            cell.imageView?.contentMode = .ScaleAspectFill
            cell.textLabel?.text = list.body ?? Translation.DataNotAvailable
            cell.textLabel?.font = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
            cell.textLabel?.textColor = UIColor.colorFromHexRGB(Color.SlateGray)
            cell.exclusiveTouch = true
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .ByWordWrapping
            cell.selectionStyle = .Default
            cell.setNeedsDisplay()
            cell.setNeedsLayout()
            cell.setNeedsUpdateConstraints()
        }
        else {
            cell.textLabel?.text = Translation.DataNotAvailable
            cell.selectionStyle = .None
        }
        return cell
    }
}
// MARK:- UITableViewDelegate
extension CommentViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

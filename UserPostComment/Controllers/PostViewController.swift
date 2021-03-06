//
//  PostViewController.swift
//  UserPostComment
//
//  Created by Roger Yong on 04/04/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import UIKit
import CoreData

class PostViewController: UIViewController {
    // MARK:- Properties
    var tableView: UITableView!
    var postList: PostList!
    var userPostComment: UserPostComment!
    
    var tableData = [AnyObject]()
    var spinner = CustomSpinner()
    
    var alertShow = false
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Notification.InsertCompleted, object: nil)
        print("deinit called")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        title = Translation.UserPost
        
        configureData()
        configureTableView()
    }
    override func viewDidAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(Selectors.ReceivedNotification.Post), name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Notification.InsertCompleted, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(Selectors.ReceivedNotification.Post), name: Notification.InsertCompleted, object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
// MARK:- UI Configuration
extension PostViewController {
    func configureData() {
        if isZeroDataCount() {
            if isNetworkOrCellularCoverageReachable() {
                addSpinner()
                userPostComment = UserPostComment()
                userPostComment.delegate = self
                userPostComment.getUserFromApi()
            }
            else {
                displayAlertWithTitle(Translation.NetworkErrorTitle, message: Translation.NetworkErrorMessage, viewController: self)
            }
        }
        else {
            addSpinner()
            getPostList()
        }
    }
    func configureTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.exclusiveTouch = true
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:Identifier.TableView.Cell)
        view.addSubview(tableView)
        
        tableView.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor).active = true
        tableView.leadingAnchor.constraintEqualToAnchor(super.view.leadingAnchor).active = true
        super.view.trailingAnchor.constraintEqualToAnchor(tableView.trailingAnchor).active = true
        bottomLayoutGuide.topAnchor.constraintEqualToAnchor(tableView.bottomAnchor).active = true
    }
}
// MARK:- Internal Action
extension PostViewController {
    func receivedNotificationPost(notification: NSNotification) {
        if notification.name == UIApplicationDidBecomeActiveNotification {
            configureData()
        }
        else if notification.name == Notification.InsertCompleted {
            getPostList()
        }
    }
    func getPostList() {
        postList = PostList()
        postList.delegate = self
        postList.getPostData()
    }
    func addSpinner() {
        if let pvc = parentViewController?.view {
            spinner.runSpinnerWithIndicator(pvc)
            spinner.start()
        }
    }
    func removeSpinner() {
        spinner.stop()
    }
}
// MARK: - UITableViewDataSource, UITableViewDelegate
extension PostViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count == 0 ? 1 : tableData.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: Identifier.TableView.Cell)
        cell.imageView?.image = userImage()
        cell.imageView?.tintColor = UIColor.colorFromHexRGB(Color.SlateGray)
        if tableData.count > 0 {
            let list = tableData[indexPath.row] as! PostList
            if let imageUrl = list.imageUrl {
                if isNetworkOrCellularCoverageReachable() {
                    TaskConfig().taskForGETImage(imageUrl, completionHandler: { (imageData, error) in
                        if let imageData = imageData {
                            if let image = UIImage(data: imageData) {
                                dispatch_async(dispatch_get_main_queue(), {
                                    cell.imageView?.image = image
                                    cell.imageView?.layer.addAnimation(imageTransition(), forKey: nil)
                                })
                            }
                        }
                    })
                }
            }
            cell.imageView?.contentMode = .ScaleAspectFill
            cell.textLabel?.text = list.title ?? Translation.DataNotAvailable
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
// MRK:: - UITableViewDelegate
extension PostViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let postlist = tableData[indexPath.row] as! PostList
        let pushVC = UIStoryboard.postDetailViewController() as PostDetailViewController!
        pushVC.postlist = postlist
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
}
// MARK:- PostListDelegate
extension PostViewController: PostListDelegate {
    func postData(data: [PostList]) {
        tableData = data
        tableView.reloadData()
        removeSpinner()
    }
}
// MARK:- 
extension PostViewController: UserPostCommentDelegate {
    func apiError() {
        alertShow = true
        let title = Translation.ApiErrorTitle
        let message = Translation.ApiErrorMessage
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: Translation.OK, style: .Default) { (alert) in
            self.alertShow = false
        }
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
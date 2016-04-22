//
//  PostDetailViewController.swift
//  UserPostComment
//
//  Created by Roger Yong on 05/04/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {

    var postlist: PostList!
    var comments: [Comment]!
    var scrollView: UIScrollView!
    var topView: UIView!
    var postInfoView: UIView!
    var commentInfoView: UIView!
    
    var totalHeight: CGFloat!
    var labelWidth: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureInit()
        configureLeftBarButtonItem()
        configureData()
        configureScrollView()
        configureTopView()
        configurePostInfoView()
        configureCommentInfoView()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSizeMake(scrollView.bounds.size.width, totalHeight)
        scrollView.layoutIfNeeded()
        scrollView.setNeedsDisplay()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
// MARK:- UI Configuration
extension PostDetailViewController {
    func configureInit() {
        self.automaticallyAdjustsScrollViewInsets = false
        title = Translation.UserPostDetail
        totalHeight = 0
        labelWidth = view.frame.width - (20*2)
    }
    func configureLeftBarButtonItem() {
        navigationItem.leftBarButtonItem = backBarButtonItem(target: self)
    }
    func configureData() {
        if let listId = postlist.id {
            comments = Comment.getCommentInfo(Int(listId))
        }
    }
    func configureScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor.colorFromHexRGB(Color.LightGray)
        view.addSubview(scrollView)
        
        scrollView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        scrollView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
        scrollView.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor).active = true
        scrollView.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.topAnchor).active = true
    }
    func configureTopView() {
        topView = UIView()
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(topView)
        
        topView.topAnchor.constraintEqualToAnchor(scrollView.topAnchor).active = true
        topView.heightAnchor.constraintEqualToConstant(50).active = true
        topView.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        
        totalHeight = totalHeight + 50
        
        let padding = 5 as CGFloat
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = userImage()
        imageView.contentMode = .ScaleAspectFill
        topView.addSubview(imageView)
        
        if isNetworkOrCellularCoverageReachable() {
            if let imageUrl = postlist.imageUrl {
                TaskConfig().taskForGETImage(imageUrl, completionHandler: { (imageData, error) in
                    if let imageData = imageData {
                        if let image = UIImage(data: imageData) {
                            dispatch_async(dispatch_get_main_queue(), {
                                imageView.image = image
                                imageView.layer.addAnimation(imageTransition(), forKey: nil)
                            })
                        }
                    }
                })
            }
        }
        let userImageHeight = userImage()?.size.height ?? 40
        imageView.leadingAnchor.constraintEqualToAnchor(topView.leadingAnchor, constant: 20).active = true
        imageView.heightAnchor.constraintEqualToConstant(userImageHeight).active = true
        imageView.widthAnchor.constraintEqualToAnchor(imageView.heightAnchor).active = true
        imageView.centerYAnchor.constraintEqualToAnchor(topView.centerYAnchor).active = true
        
        let username = postlist.username ?? Translation.DataNotAvailable
        
        let usernameButton = UIButton(type: .Custom)
        usernameButton.translatesAutoresizingMaskIntoConstraints = false
        usernameButton.setTitle(username, forState: .Normal)
        usernameButton.setTitle(username, forState: .Highlighted)
        usernameButton.setTitleColor(UIColor.colorFromHexRGB(Color.Blue), forState: .Normal)
        usernameButton.setTitleColor(UIColor.colorFromHexRGB(Color.SlateGray), forState: .Highlighted)
        usernameButton.titleLabel?.font = UIFont.systemFontOfSize(18, weight: UIFontWeightBold)
        usernameButton.contentVerticalAlignment = .Center
        usernameButton.contentHorizontalAlignment = .Left
        usernameButton.addTarget(self, action: Selector(Selectors.GotoUserInfo), forControlEvents: .TouchUpInside)
        topView.addSubview(usernameButton)
        
        usernameButton.leadingAnchor.constraintEqualToAnchor(imageView.trailingAnchor, constant: padding).active = true
        topView.trailingAnchor.constraintEqualToAnchor(usernameButton.trailingAnchor, constant: padding).active = true
        usernameButton.centerYAnchor.constraintEqualToAnchor(topView.centerYAnchor).active = true
    }
    func configurePostInfoView() {
        postInfoView = UIView()
        postInfoView.translatesAutoresizingMaskIntoConstraints = false
        postInfoView.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(postInfoView)
        
        var postInfoViewHeight = 0 as CGFloat
        
        let titleText = postlist.title ?? Translation.DataNotAvailable
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = titleText
        titleLabel.textColor = UIColor.colorFromHexRGB(Color.SlateGray)
        titleLabel.font = UIFont.systemFontOfSize(16, weight: UIFontWeightSemibold)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .ByClipping
        titleLabel.adjustsFontSizeToFitWidth = true
        postInfoView.addSubview(titleLabel)
        
        let expectFrameForTitleLabel = titleLabel.font.sizeOfString(titleText, constrainedToWidth: labelWidth)

        titleLabel.topAnchor.constraintEqualToAnchor(postInfoView.topAnchor, constant: 10).active = true
        titleLabel.widthAnchor.constraintEqualToConstant(labelWidth).active = true
        titleLabel.heightAnchor.constraintEqualToConstant(expectFrameForTitleLabel.height).active = true
        titleLabel.centerXAnchor.constraintEqualToAnchor(postInfoView.centerXAnchor).active = true
        
        postInfoViewHeight = postInfoViewHeight + 10 + expectFrameForTitleLabel.height

        let underline = UILabel()
        underline.translatesAutoresizingMaskIntoConstraints = false
        underline.backgroundColor = UIColor.lightGrayColor()
        postInfoView.addSubview(underline)
        
        underline.topAnchor.constraintEqualToAnchor(titleLabel.bottomAnchor, constant: 3).active = true
        underline.leadingAnchor.constraintEqualToAnchor(postInfoView.leadingAnchor).active = true
        underline.trailingAnchor.constraintEqualToAnchor(postInfoView.trailingAnchor).active = true
        underline.heightAnchor.constraintEqualToConstant(1).active = true
        
        postInfoViewHeight = postInfoViewHeight + 1 + 3
        
        let bodyText = postlist.body ?? Translation.DataNotAvailable
        
        let bodyLabel = UILabel()
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.text = bodyText
        bodyLabel.textColor = UIColor.colorFromHexRGB(Color.SlateGray)
        bodyLabel.font = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
        bodyLabel.numberOfLines = 0
        bodyLabel.lineBreakMode = .ByClipping
        bodyLabel.adjustsFontSizeToFitWidth = true
        postInfoView.addSubview(bodyLabel)
        
        let expectFrameForBodyLabel = bodyLabel.font.sizeOfString(bodyText, constrainedToWidth: labelWidth)
        
        bodyLabel.topAnchor.constraintEqualToAnchor(underline.bottomAnchor, constant: 10).active = true
        bodyLabel.widthAnchor.constraintEqualToConstant(labelWidth).active = true
        bodyLabel.heightAnchor.constraintEqualToConstant(expectFrameForBodyLabel.height).active = true
        bodyLabel.centerXAnchor.constraintEqualToAnchor(postInfoView.centerXAnchor).active = true
        postInfoView.bottomAnchor.constraintEqualToAnchor(bodyLabel.bottomAnchor, constant: 10).active = true
        
        postInfoViewHeight = postInfoViewHeight + 10 + expectFrameForBodyLabel.height + 10
        
        postInfoView.topAnchor.constraintEqualToAnchor(topView.bottomAnchor, constant: 20).active = true
        postInfoView.heightAnchor.constraintEqualToConstant(postInfoViewHeight).active = true
        postInfoView.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true

        totalHeight = totalHeight + postInfoViewHeight
    }
    func configureCommentInfoView() {
        commentInfoView = UIView()
        commentInfoView.translatesAutoresizingMaskIntoConstraints = false
        commentInfoView.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(commentInfoView)
        
        commentInfoView.topAnchor.constraintEqualToAnchor(postInfoView.bottomAnchor, constant: 20).active = true
        commentInfoView.heightAnchor.constraintEqualToConstant(35).active = true
        commentInfoView.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        
        let commentText = comments.count > 1 ? "COMMENTS :" : "COMMENT :"
        
        let commentLabel = UILabel()
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.text = commentText
        commentLabel.textColor = UIColor.colorFromHexRGB(Color.SlateGray)
        commentLabel.font = UIFont.systemFontOfSize(16, weight: UIFontWeightSemibold)
        commentInfoView.addSubview(commentLabel)
        
        let expectFrameForCommentLabel = commentLabel.font.sizeOfString(commentText, constrainedToWidth: labelWidth)
        
        commentLabel.leadingAnchor.constraintEqualToAnchor(commentInfoView.leadingAnchor, constant: 20).active = true
        commentLabel.heightAnchor.constraintEqualToConstant(expectFrameForCommentLabel.height).active = true
        commentLabel.centerYAnchor.constraintEqualToAnchor(commentInfoView.centerYAnchor).active = true
        
        let commentButton = UIButton(type: .Custom)
        commentButton.translatesAutoresizingMaskIntoConstraints = false
        commentButton.setTitle(String(comments.count), forState: .Normal)
        commentButton.setTitle(String(comments.count), forState: .Highlighted)
        commentButton.setTitleColor(UIColor.colorFromHexRGB(Color.Blue), forState: .Normal)
        commentButton.setTitleColor(UIColor.colorFromHexRGB(Color.SlateGray), forState: .Highlighted)
        commentButton.titleLabel?.font = UIFont.systemFontOfSize(18, weight: UIFontWeightBold)
        commentButton.contentVerticalAlignment = .Center
        commentButton.contentHorizontalAlignment = .Left
        commentButton.addTarget(self, action: Selector(Selectors.GotoComments), forControlEvents: .TouchUpInside)
        commentInfoView.addSubview(commentButton)
        
        commentButton.leadingAnchor.constraintEqualToAnchor(commentLabel.trailingAnchor, constant: 5).active = true
        commentButton.centerYAnchor.constraintEqualToAnchor(commentInfoView.centerYAnchor).active = true
        commentButton.heightAnchor.constraintEqualToAnchor(commentLabel.heightAnchor).active = true
        commentButton.widthAnchor.constraintEqualToAnchor(commentButton.heightAnchor).active = true

        totalHeight = totalHeight + 50
    }
}
// MARK:- Intenal Action
extension PostDetailViewController {
    func goBack() {
        navigationController?.popViewControllerAnimated(true)
    }
    func gotoUserInfo(sender: UIButton) {
        if let userId = postlist.userId {
            let pushVC = UIStoryboard.userViewController() as UserViewController!
            pushVC.userId = userId
            navigationController?.pushViewController(pushVC, animated: true)
        }
        else {
            displayAlertWithTitle(Translation.Sorry, message: Translation.UserInformationNotAvailable, viewController: self)
        }
    }
    func gotoComments(sender: UIButton) {
        parentViewController?.view.alpha = 0.5
        let presentVC = UIStoryboard.commentViewController() as CommentViewController!
        presentVC.modalPresentationStyle = .Custom
        presentVC.transitioningDelegate = self
        presentVC.tableData = comments
        presentVC.delegate = self
        presentViewController(presentVC, animated: true, completion: nil)
    }
}
// MARK:- CommentViewControllerDelegate
extension PostDetailViewController: CommentViewControllerDelegate {
    func removeBackgroundView() {
        parentViewController?.view.alpha = 1.0
    }
}
// MARK:- UIViewControllerTransitioningDelegate
extension PostDetailViewController: UIViewControllerTransitioningDelegate {
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return CenterPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
}
// MARK:- UIPresentationController
class CenterPresentationController : UIPresentationController {
    override func frameOfPresentedViewInContainerView() -> CGRect {
        var rect: CGRect!
        if let containerView = containerView {
            rect = CGRect(x: 0, y: containerView.bounds.height/2, width: containerView.bounds.width, height: containerView.bounds.height/2)
        } else {
            rect = CGRectZero
        }
        return rect
    }
}


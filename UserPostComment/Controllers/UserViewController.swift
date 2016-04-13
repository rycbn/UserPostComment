//
//  UserViewController.swift
//  UserPostComment
//
//  Created by Roger Yong on 05/04/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class UserViewController: UIViewController {
    // MARK:- Properties
    var scrollView: UIScrollView!
    var topView: UIView!
    var addressView: UIView!
    var companyView: UIView!
    var contactView: UIView!
    var addressHeaderLabel: UILabel!
    var companyHeaderLabel: UILabel!
    var contactHeaderLabel: UILabel!
    var totalHeight: CGFloat!
    var labelWidth: CGFloat!
    var userId: NSNumber!
    var userInfo: User!
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureInit()
        configureLeftBarButtonItem()
        configureData()
        configureScrollView()
        configureTopView()
        configureAddressHeader()
        configureMapView()
        configureAddressView()
        configureCompanyHeader()
        configureCompanyView()
        configureContactHeader()
        configureContactView()
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
// MARK:- UIConfiguration
extension UserViewController {
    func configureInit() {
        self.automaticallyAdjustsScrollViewInsets = false
        title = Translation.UserInformation
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        totalHeight = 0
        labelWidth = view.frame.width - (20*2)
    }
    func configureLeftBarButtonItem() {
        navigationItem.leftBarButtonItem = backBarButtonItem(target: self)
    }
    func configureData() {
        userInfo = User.getUserInfo(Int(userId))
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
        let imageUrl = String(format: "https://api.adorable.io/avatars/40/%@@adorable.png", userInfo.username!)
        if isNetworkOrCellularCoverageReachable() {
            TaskConfig().taskForGETImage(imageUrl, completionHandler: { (imageData, error) in
                if let image = UIImage(data: imageData!) {
                    dispatch_async(dispatch_get_main_queue(), {
                        imageView.image = image
                        let transition = CATransition()
                        transition.duration = 1.0
                        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                        transition.type = kCATransitionFade
                        transition.delegate = self
                        imageView.layer.addAnimation(transition, forKey: nil)
                    })
                }
                else {
                    print(error)
                }
            })
        }
        imageView.leadingAnchor.constraintEqualToAnchor(topView.leadingAnchor, constant: 20).active = true
        imageView.heightAnchor.constraintEqualToConstant(userImage().size.height).active = true
        imageView.widthAnchor.constraintEqualToAnchor(imageView.heightAnchor).active = true
        imageView.centerYAnchor.constraintEqualToAnchor(topView.centerYAnchor).active = true

        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = userInfo.name!
        nameLabel.textColor = UIColor.colorFromHexRGB(Color.SlateGray)
        nameLabel.font = UIFont.systemFontOfSize(16, weight: UIFontWeightBold)
        topView.addSubview(nameLabel)
        
        nameLabel.topAnchor.constraintEqualToAnchor(topView.topAnchor, constant: 5).active = true
        nameLabel.leadingAnchor.constraintEqualToAnchor(imageView.trailingAnchor, constant: padding).active = true
        topView.trailingAnchor.constraintEqualToAnchor(nameLabel.trailingAnchor, constant: padding).active = true
        
        let usernameLabel = UILabel()
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.text = String(format: "(%@)", userInfo.username!)
        usernameLabel.textColor = UIColor.colorFromHexRGB(Color.SlateGray)
        usernameLabel.font = UIFont.systemFontOfSize(14, weight: UIFontWeightSemibold)
        topView.addSubview(usernameLabel)
        
        usernameLabel.topAnchor.constraintEqualToAnchor(nameLabel.bottomAnchor, constant: 3).active = true
        usernameLabel.leadingAnchor.constraintEqualToAnchor(nameLabel.leadingAnchor).active = true
        usernameLabel.trailingAnchor.constraintEqualToAnchor(nameLabel.trailingAnchor).active = true
    }
    func configureAddressHeader() {
        addressHeaderLabel = UILabel()
        addressHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        addressHeaderLabel.text = Translation.Address.uppercaseString
        addressHeaderLabel.textColor = UIColor.colorFromHexRGB(Color.SlateGray)
        addressHeaderLabel.font = UIFont.systemFontOfSize(16, weight: UIFontWeightSemibold)
        scrollView.addSubview(addressHeaderLabel)
        
        addressHeaderLabel.leadingAnchor.constraintEqualToAnchor(scrollView.leadingAnchor, constant: 20).active = true
        scrollView.trailingAnchor.constraintEqualToAnchor(addressHeaderLabel.trailingAnchor, constant: 20).active = true
        addressHeaderLabel.topAnchor.constraintEqualToAnchor(topView.bottomAnchor, constant: 20).active = true
        addressHeaderLabel.heightAnchor.constraintEqualToConstant(15).active = true
        
        totalHeight = totalHeight + 15 + 20
    }
    func configureMapView() {
        mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.mapType = .Standard
        mapView.showsUserLocation = true
        mapView.showsPointsOfInterest = true
        mapView.showsBuildings = true
        mapView.zoomEnabled = true
        mapView.rotateEnabled = false
        
        //mapView.userInteractionEnabled = false
        scrollView.addSubview(mapView)

        mapView.topAnchor.constraintEqualToAnchor(addressHeaderLabel.bottomAnchor, constant: 5).active = true
        mapView.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        mapView.heightAnchor.constraintEqualToConstant(100).active = true
        
        totalHeight = totalHeight + 100 + 5
    }
    func configureAddressView() {
        addressView = UIView()
        addressView.translatesAutoresizingMaskIntoConstraints = false
        addressView.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(addressView)
        
        var addressViewHeight = 0 as CGFloat
        
        let suiteLabel = UILabel()
        suiteLabel.translatesAutoresizingMaskIntoConstraints = false
        suiteLabel.text = userInfo.address?.suite!
        suiteLabel.textColor = UIColor.colorFromHexRGB(Color.SlateGray)
        suiteLabel.font = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
        addressView.addSubview(suiteLabel)
        
        let expectFrameSuiteLabel = suiteLabel.font.sizeOfString(suiteLabel.text!, constrainedToWidth: labelWidth)
        
        suiteLabel.topAnchor.constraintEqualToAnchor(addressView.topAnchor, constant: 5).active = true
        suiteLabel.leadingAnchor.constraintEqualToAnchor(addressView.leadingAnchor, constant: 20).active = true
        suiteLabel.heightAnchor.constraintEqualToConstant(expectFrameSuiteLabel.height).active = true
        addressView.trailingAnchor.constraintEqualToAnchor(suiteLabel.trailingAnchor, constant: 20).active = true
        
        addressViewHeight = addressViewHeight + expectFrameSuiteLabel.height + 5
        
        let streetLabel = UILabel()
        streetLabel.translatesAutoresizingMaskIntoConstraints = false
        streetLabel.text = userInfo.address?.street!
        streetLabel.textColor = UIColor.colorFromHexRGB(Color.SlateGray)
        streetLabel.font = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
        addressView.addSubview(streetLabel)
        
        let expectFrameStreetLabel = streetLabel.font.sizeOfString(streetLabel.text!, constrainedToWidth: labelWidth)
        
        streetLabel.topAnchor.constraintEqualToAnchor(suiteLabel.bottomAnchor, constant: 2).active = true
        streetLabel.leadingAnchor.constraintEqualToAnchor(addressView.leadingAnchor, constant: 20).active = true
        streetLabel.heightAnchor.constraintEqualToConstant(expectFrameStreetLabel.height).active = true
        addressView.trailingAnchor.constraintEqualToAnchor(streetLabel.trailingAnchor, constant: 20).active = true
        
        addressViewHeight = addressViewHeight + expectFrameStreetLabel.height + 2
        
        let cityLabel = UILabel()
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.text = userInfo.address?.city!
        cityLabel.textColor = UIColor.colorFromHexRGB(Color.SlateGray)
        cityLabel.font = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
        addressView.addSubview(cityLabel)
        
        let expectFrameCityLabel = cityLabel.font.sizeOfString(cityLabel.text!, constrainedToWidth: labelWidth)
        
        cityLabel.topAnchor.constraintEqualToAnchor(streetLabel.bottomAnchor, constant: 2).active = true
        cityLabel.leadingAnchor.constraintEqualToAnchor(addressView.leadingAnchor, constant: 20).active = true
        cityLabel.heightAnchor.constraintEqualToConstant(expectFrameCityLabel.height).active = true
        addressView.trailingAnchor.constraintEqualToAnchor(cityLabel.trailingAnchor, constant: 20).active = true

        addressViewHeight = addressViewHeight + expectFrameCityLabel.height + 2
        
        let zipcodeLabel = UILabel()
        zipcodeLabel.translatesAutoresizingMaskIntoConstraints = false
        zipcodeLabel.text = userInfo.address?.zipcode!
        zipcodeLabel.textColor = UIColor.colorFromHexRGB(Color.SlateGray)
        zipcodeLabel.font = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
        addressView.addSubview(zipcodeLabel)
        
        let expectFrameZipcodeLabel = zipcodeLabel.font.sizeOfString(zipcodeLabel.text!, constrainedToWidth: labelWidth)
        
        zipcodeLabel.topAnchor.constraintEqualToAnchor(cityLabel.bottomAnchor, constant: 2).active = true
        zipcodeLabel.leadingAnchor.constraintEqualToAnchor(addressView.leadingAnchor, constant: 20).active = true
        zipcodeLabel.heightAnchor.constraintEqualToConstant(expectFrameZipcodeLabel.height).active = true
        addressView.trailingAnchor.constraintEqualToAnchor(zipcodeLabel.trailingAnchor, constant: 20).active = true
        addressView.bottomAnchor.constraintEqualToAnchor(zipcodeLabel.bottomAnchor, constant: 5).active = true

        addressViewHeight = addressViewHeight + expectFrameZipcodeLabel.height + 2 + 5

        addressView.topAnchor.constraintEqualToAnchor(mapView.bottomAnchor).active = true
        addressView.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        addressView.heightAnchor.constraintEqualToConstant(addressViewHeight).active = true
        
        totalHeight = totalHeight + addressViewHeight
    }
    func configureCompanyHeader() {
        companyHeaderLabel = UILabel()
        companyHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        companyHeaderLabel.text = Translation.Company.uppercaseString
        companyHeaderLabel.textColor = UIColor.colorFromHexRGB(Color.SlateGray)
        companyHeaderLabel.font = UIFont.systemFontOfSize(16, weight: UIFontWeightSemibold)
        scrollView.addSubview(companyHeaderLabel)
        
        companyHeaderLabel.topAnchor.constraintEqualToAnchor(addressView.bottomAnchor, constant: 20).active = true
        companyHeaderLabel.leadingAnchor.constraintEqualToAnchor(scrollView.leadingAnchor, constant: 20).active = true
        companyHeaderLabel.heightAnchor.constraintEqualToConstant(15).active = true
        scrollView.trailingAnchor.constraintEqualToAnchor(companyHeaderLabel.trailingAnchor, constant: 20).active = true
        
        totalHeight = totalHeight + 15 + 20
    }
    func configureCompanyView() {
        companyView = UIView()
        companyView.translatesAutoresizingMaskIntoConstraints = false
        companyView.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(companyView)
        
        var companyViewHeight = 0 as CGFloat
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = userInfo.company?.name!
        nameLabel.textColor = UIColor.colorFromHexRGB(Color.SlateGray)
        nameLabel.font = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
        companyView.addSubview(nameLabel)
        
        let expectFrameNameLabel = nameLabel.font.sizeOfString(nameLabel.text!, constrainedToWidth: labelWidth)
        
        nameLabel.topAnchor.constraintEqualToAnchor(companyView.topAnchor, constant: 5).active = true
        nameLabel.leadingAnchor.constraintEqualToAnchor(companyView.leadingAnchor, constant: 20).active = true
        nameLabel.heightAnchor.constraintEqualToConstant(expectFrameNameLabel.height).active = true
        companyView.trailingAnchor.constraintEqualToAnchor(nameLabel.trailingAnchor, constant: 20).active = true
        
        companyViewHeight = companyViewHeight + expectFrameNameLabel.height + 5
        
        let catchPhraseLabel = UILabel()
        catchPhraseLabel.translatesAutoresizingMaskIntoConstraints = false
        catchPhraseLabel.text = userInfo.company?.catchPhrase!
        catchPhraseLabel.textColor = UIColor.colorFromHexRGB(Color.SlateGray)
        catchPhraseLabel.font = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
        companyView.addSubview(catchPhraseLabel)
        
        let expectFrameCatchPhraseLabel = catchPhraseLabel.font.sizeOfString(catchPhraseLabel.text!, constrainedToWidth: labelWidth)
        
        catchPhraseLabel.topAnchor.constraintEqualToAnchor(nameLabel.bottomAnchor, constant: 2).active = true
        catchPhraseLabel.leadingAnchor.constraintEqualToAnchor(companyView.leadingAnchor, constant: 20).active = true
        catchPhraseLabel.heightAnchor.constraintEqualToConstant(expectFrameCatchPhraseLabel.height).active = true
        companyView.trailingAnchor.constraintEqualToAnchor(catchPhraseLabel.trailingAnchor, constant: 20).active = true
        
        companyViewHeight = companyViewHeight + expectFrameCatchPhraseLabel.height + 2
        
        let bsLabel = UILabel()
        bsLabel.translatesAutoresizingMaskIntoConstraints = false
        bsLabel.text = userInfo.company?.bs!
        bsLabel.textColor = UIColor.colorFromHexRGB(Color.SlateGray)
        bsLabel.font = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
        companyView.addSubview(bsLabel)
        
        let expectFrameBsLabel = bsLabel.font.sizeOfString(bsLabel.text!, constrainedToWidth: labelWidth)
        
        bsLabel.topAnchor.constraintEqualToAnchor(catchPhraseLabel.bottomAnchor, constant: 2).active = true
        bsLabel.leadingAnchor.constraintEqualToAnchor(companyView.leadingAnchor, constant: 20).active = true
        bsLabel.heightAnchor.constraintEqualToConstant(expectFrameBsLabel.height).active = true
        companyView.trailingAnchor.constraintEqualToAnchor(bsLabel.trailingAnchor, constant: 20).active = true
        companyView.bottomAnchor.constraintEqualToAnchor(bsLabel.bottomAnchor, constant: 5).active = true
        
        companyViewHeight = companyViewHeight + expectFrameBsLabel.height + 2 + 5
        
        companyView.topAnchor.constraintEqualToAnchor(companyHeaderLabel.bottomAnchor, constant: 5).active = true
        companyView.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        companyView.heightAnchor.constraintEqualToConstant(companyViewHeight).active = true
        
        totalHeight = totalHeight + companyViewHeight + 5
    }
    func configureContactHeader() {
        contactHeaderLabel = UILabel()
        contactHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        contactHeaderLabel.text = Translation.Contact.uppercaseString
        contactHeaderLabel.textColor = UIColor.colorFromHexRGB(Color.SlateGray)
        contactHeaderLabel.font = UIFont.systemFontOfSize(16, weight: UIFontWeightSemibold)
        scrollView.addSubview(contactHeaderLabel)
        
        contactHeaderLabel.topAnchor.constraintEqualToAnchor(companyView.bottomAnchor, constant: 20).active = true
        contactHeaderLabel.leadingAnchor.constraintEqualToAnchor(scrollView.leadingAnchor, constant: 20).active = true
        contactHeaderLabel.heightAnchor.constraintEqualToConstant(15).active = true
        scrollView.trailingAnchor.constraintEqualToAnchor(contactHeaderLabel.trailingAnchor, constant: 20).active = true
        
        totalHeight = totalHeight + 15 + 20
    }
    func configureContactView() {
        contactView = UIView()
        contactView.translatesAutoresizingMaskIntoConstraints = false
        contactView.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(contactView)
        
        var contactViewHeight = 0 as CGFloat
        
        let phoneLabel = UILabel()
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneLabel.text = Translation.Phone
        phoneLabel.textColor = UIColor.colorFromHexRGB(Color.SlateGray)
        phoneLabel.font = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
        phoneLabel.lineBreakMode = .ByClipping
        contactView.addSubview(phoneLabel)
        
        let expectFramePhoneLabel = phoneLabel.font.sizeOfString(phoneLabel.text!, constrainedToWidth: labelWidth)
        
        phoneLabel.topAnchor.constraintEqualToAnchor(contactView.topAnchor, constant: 5).active = true
        phoneLabel.leadingAnchor.constraintEqualToAnchor(contactView.leadingAnchor, constant: 20).active = true
        phoneLabel.heightAnchor.constraintEqualToConstant(expectFramePhoneLabel.height).active = true
        phoneLabel.widthAnchor.constraintEqualToConstant(expectFramePhoneLabel.width).active = true

        contactViewHeight = contactViewHeight + expectFramePhoneLabel.height + 5
        
        let phoneTextView = UITextView()
        phoneTextView.translatesAutoresizingMaskIntoConstraints = false
        phoneTextView.text = userInfo.phone!
        phoneTextView.scrollEnabled = false
        phoneTextView.editable = false
        phoneTextView.textAlignment = .Right
        phoneTextView.textContainer.lineFragmentPadding = 0
        phoneTextView.textContainerInset = UIEdgeInsetsZero
        phoneTextView.dataDetectorTypes = .All
        phoneTextView.font = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
        contactView.addSubview(phoneTextView)
        
        phoneTextView.topAnchor.constraintEqualToAnchor(phoneLabel.topAnchor).active = true
        contactView.trailingAnchor.constraintEqualToAnchor(phoneTextView.trailingAnchor, constant: 20).active = true
        phoneTextView.leadingAnchor.constraintEqualToAnchor(phoneLabel.trailingAnchor, constant: 5).active = true
        phoneTextView.heightAnchor.constraintEqualToAnchor(phoneLabel.heightAnchor).active = true
        
        let emailLabel = UILabel()
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.text = Translation.Email
        emailLabel.textColor = UIColor.colorFromHexRGB(Color.SlateGray)
        emailLabel.font = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
        emailLabel.lineBreakMode = .ByClipping
        contactView.addSubview(emailLabel)
        
        let expectFrameEmailLabel = emailLabel.font.sizeOfString(emailLabel.text!, constrainedToWidth: labelWidth)
        
        emailLabel.topAnchor.constraintEqualToAnchor(phoneLabel.bottomAnchor, constant: 10).active = true
        emailLabel.leadingAnchor.constraintEqualToAnchor(contactView.leadingAnchor, constant: 20).active = true
        emailLabel.heightAnchor.constraintEqualToConstant(expectFrameEmailLabel.height).active = true
        emailLabel.widthAnchor.constraintEqualToConstant(expectFrameEmailLabel.width).active = true
        
        contactViewHeight = contactViewHeight + expectFrameEmailLabel.height + 10

        let emailTextView = UITextView()
        emailTextView.translatesAutoresizingMaskIntoConstraints = false
        emailTextView.text = userInfo.email!
        emailTextView.scrollEnabled = false
        emailTextView.editable = false
        emailTextView.textAlignment = .Right
        emailTextView.textContainer.lineFragmentPadding = 0
        emailTextView.textContainerInset = UIEdgeInsetsZero
        emailTextView.dataDetectorTypes = .All
        emailTextView.font = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
        contactView.addSubview(emailTextView)
        
        emailTextView.topAnchor.constraintEqualToAnchor(emailLabel.topAnchor).active = true
        contactView.trailingAnchor.constraintEqualToAnchor(emailTextView.trailingAnchor, constant: 20).active = true
        emailTextView.leadingAnchor.constraintEqualToAnchor(emailLabel.trailingAnchor, constant: 5).active = true
        emailTextView.heightAnchor.constraintEqualToAnchor(emailLabel.heightAnchor).active = true
        
        let websiteLabel = UILabel()
        websiteLabel.translatesAutoresizingMaskIntoConstraints = false
        websiteLabel.text = Translation.Website
        websiteLabel.textColor = UIColor.colorFromHexRGB(Color.SlateGray)
        websiteLabel.font = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
        websiteLabel.lineBreakMode = .ByClipping
        contactView.addSubview(websiteLabel)
        
        let expectFrameWebsiteLabel = websiteLabel.font.sizeOfString(websiteLabel.text!, constrainedToWidth: labelWidth)
        
        websiteLabel.topAnchor.constraintEqualToAnchor(emailLabel.bottomAnchor, constant: 10).active = true
        websiteLabel.leadingAnchor.constraintEqualToAnchor(contactView.leadingAnchor, constant: 20).active = true
        websiteLabel.heightAnchor.constraintEqualToConstant(expectFrameWebsiteLabel.height).active = true
        websiteLabel.widthAnchor.constraintEqualToConstant(expectFrameWebsiteLabel.width).active = true
        contactView.bottomAnchor.constraintEqualToAnchor(websiteLabel.bottomAnchor, constant: 10).active = true
        
        contactViewHeight = contactViewHeight + expectFrameWebsiteLabel.height + 10 + 10
        
        let websiteTextView = UITextView()
        websiteTextView.translatesAutoresizingMaskIntoConstraints = false
        websiteTextView.text = userInfo.website!
        websiteTextView.scrollEnabled = false
        websiteTextView.editable = false
        websiteTextView.textAlignment = .Right
        websiteTextView.textContainer.lineFragmentPadding = 0
        websiteTextView.textContainerInset = UIEdgeInsetsZero
        websiteTextView.dataDetectorTypes = .All
        websiteTextView.font = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
        contactView.addSubview(websiteTextView)
        
        websiteTextView.topAnchor.constraintEqualToAnchor(websiteLabel.topAnchor).active = true
        contactView.trailingAnchor.constraintEqualToAnchor(websiteTextView.trailingAnchor, constant: 20).active = true
        websiteTextView.leadingAnchor.constraintEqualToAnchor(websiteLabel.trailingAnchor, constant: 5).active = true
        websiteTextView.heightAnchor.constraintEqualToAnchor(websiteLabel.heightAnchor).active = true
        
        contactView.topAnchor.constraintEqualToAnchor(contactHeaderLabel.bottomAnchor, constant: 5).active = true
        contactView.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        contactView.heightAnchor.constraintEqualToConstant(contactViewHeight).active = true
        //print(contactViewHeight)
        totalHeight = totalHeight + contactViewHeight + 5
        //print(totalHeight)
    }
}
// MARK:- Internal Action
extension UserViewController {
    func goBack() {
        navigationController?.popViewControllerAnimated(true)
    }
}
// MARK:- CLLocationManagerDelegate
extension UserViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            mapView.showsUserLocation = (status == .AuthorizedWhenInUse)
        }
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latitude = userInfo.address!.geo!.latitude! //51.5158626
        let longitude = userInfo.address!.geo!.longitude! //-0.0798606
        let coordinate = CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!)
        zoomToLocationInMapView(mapView, coordinate: coordinate)
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location Manager failed with the following error: \(error)")
    }
}
// MARK:- MKMapViewDelegate
extension UserViewController: MKMapViewDelegate {
    /*
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        mapView.centerCoordinate = (userLocation.location?.coordinate)!
    }
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = Identifier.MapView.Annotation
        let latitude = userInfo.address!.geo!.latitude!
        let longitude = userInfo.address!.geo!.longitude!
        let coordinate = CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!)
        let annotation = Location(city: userInfo.address!.city!, coordinate: coordinate)
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("%f %f",mapView.centerCoordinate.latitude,mapView.centerCoordinate.longitude)
    }
    */
}

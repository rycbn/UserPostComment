//
//  FuncValidate.swift
//  UserPostComment
//
//  Created by Roger Yong on 06/04/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import UIKit
import CoreTelephony

func hasCellularCoverage() -> Bool {
    let carrier = CTCarrier()
    let subscriber = CTSubscriber()
    if !(carrier.mobileCountryCode != nil) { return false }
    if !(subscriber.carrierToken != nil) { return false }
    return true
}
func isNetworkOrCellularCoverageReachable() -> Bool  {
    if let reachability = Reachability.reachabilityForInternetConnection() {
        return (reachability.isReachable() || hasCellularCoverage())
    }
    return false
}
func isReachableViaWifi() -> Bool {
    if let reachability = Reachability.reachabilityForInternetConnection() {
        return reachability.isReachableViaWiFi()
    }
    return false
}
func isZeroDataCount() -> Bool {
    let userCount = CoreDataOperation.objectCountForEntity(EntityName.User, context: objContext())
    let postCount = CoreDataOperation.objectCountForEntity(EntityName.Post, context: objContext())
    let commentCount = CoreDataOperation.objectCountForEntity(EntityName.Comment, context: objContext())
    if userCount == 0 && postCount == 0 && commentCount  == 0 {
        return true
    }
    return false
}
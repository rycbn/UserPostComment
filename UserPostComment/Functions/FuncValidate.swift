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
    let reachability = Reachability.reachabilityForInternetConnection()
    return (reachability!.isReachable() || hasCellularCoverage())
}
func isReachableViaWifi() -> Bool {
    let reachability = Reachability.reachabilityForInternetConnection()
    return reachability!.isReachableViaWiFi()
}
func isZeroDataCount() -> Bool {
    let userCount = CoreDataOperation.objectCountForEntity(EntityName.User, context: context())
    let postCount = CoreDataOperation.objectCountForEntity(EntityName.Post, context: context())
    let commentCount = CoreDataOperation.objectCountForEntity(EntityName.Comment, context: context())
    if userCount == 0 && postCount == 0 && commentCount  == 0 {
        return true
    }
    return false
}
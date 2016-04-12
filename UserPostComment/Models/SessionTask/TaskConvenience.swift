//
//  TaskConvenience.swift
//  UserPostComment
//
//  Created by Roger Yong on 04/04/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import Foundation

extension TaskConfig {
    func getUserData(completionHandler: (results: [AnyObject]?, error: NSError?) -> Void) {
        let parameters = [String: AnyObject]()
        let mutableMethod: String = Methods.Users
        taskForGETMethod(mutableMethod, parameters: parameters) { (JSONResult, error) in
            if let error = error {
                completionHandler(results: nil, error: error)
            }
            else {
                if let result = JSONResult as? [AnyObject] {
                    completionHandler(results: result, error: nil)
                }
                else {
                    completionHandler(results: nil, error: NSError(domain: "\(#function) parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse \(#function)"]))
                }
            }
        }
    }
    func getPostData(completionHandler: (results: [AnyObject]?, error: NSError?) -> Void) {
        let parameters = [String: AnyObject]()
        let mutableMethod: String = Methods.Posts
        taskForGETMethod(mutableMethod, parameters: parameters) { (JSONResult, error) in
            if let error = error {
                completionHandler(results: nil, error: error)
            }
            else {
                if let result = JSONResult as? [AnyObject] {
                    completionHandler(results: result, error: nil)
                }
                else {
                    completionHandler(results: nil, error: NSError(domain: "\(#function) parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse \(#function)"]))
                }
            }
        }
    }
    func getCommentData(completionHandler: (results: [AnyObject]?, error: NSError?) -> Void) {
        let parameters = [String: AnyObject]()
        let mutableMethod: String = Methods.Comments
        taskForGETMethod(mutableMethod, parameters: parameters) { (JSONResult, error) in
            if let error = error {
                completionHandler(results: nil, error: error)
            }
            else {
                if let result = JSONResult as? [AnyObject] {
                    completionHandler(results: result, error: nil)
                }
                else {
                    completionHandler(results: nil, error: NSError(domain: "\(#function) parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse \(#function)"]))
                }
            }
        }
    }
}
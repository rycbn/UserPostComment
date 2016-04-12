//
//  TaskConfig.swift
//  UserPostComment
//
//  Created by Roger Yong on 04/04/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import Foundation

class TaskConfig: NSObject {
    var session: NSURLSession
    
    override init() {
        let congifuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: congifuration)
        super.init()
    }
    // MARK:- GET
    func taskForGETMethod(method: String, parameters: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let mutableParameters = parameters
        
        let urlString = ApiUrl.Base + method + TaskConfig.escapedParameters(mutableParameters)
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                let errorBody: [String: AnyObject] = [JsonErrorKey.Error: JsonErrorValue.Error]
                var errorData: NSData!
                do {
                    errorData = try! NSJSONSerialization.dataWithJSONObject(errorBody, options: .PrettyPrinted)
                }
                TaskConfig.parseJSONDataWithCompletionHandler(errorData, completionHandler: completionHandler)
                return
            }
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                let errorBody: [String: AnyObject] = [JsonErrorKey.Error: JsonErrorValue.BadRequest]
                var errorData: NSData!
                do {
                    errorData = try! NSJSONSerialization.dataWithJSONObject(errorBody, options: .PrettyPrinted)
                }
                TaskConfig.parseJSONDataWithCompletionHandler(errorData, completionHandler: completionHandler)
                return
            }
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                //print("No data was returned by the request!")
                let errorBody: [String: AnyObject] = [JsonErrorKey.Error: JsonErrorValue.NoData]
                var errorData: NSData!
                do {
                    errorData = try! NSJSONSerialization.dataWithJSONObject(errorBody, options: .PrettyPrinted)
                }
                TaskConfig.parseJSONDataWithCompletionHandler(errorData, completionHandler: completionHandler)
                return
            }
            TaskConfig.parseJSONDataWithCompletionHandler(data, completionHandler: completionHandler)
        }
        task.resume()
        return task
    }
    func taskForGETImage(imageUrl: String, completionHandler: (imageData: NSData?, error: NSError?) ->  Void) -> NSURLSessionTask {
        let url = NSURL(string: imageUrl)!
        let request = NSMutableURLRequest(URL: url, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            completionHandler(imageData: data, error: nil)
        }
        /* 7. Start the request */
        task.resume()
        return task
    }
    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONDataWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandler(result: parsedResult, error: nil)
    }
    /* Helper: Substitute the key for the value that is contained within the method name */
    class func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        var urlVars = [String]()
        for (key, value) in parameters {
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
        }
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    // MARK:- Shared Instance
    class func sharedInstance() -> TaskConfig {
        struct Singleton {
            static var sharedInstance = TaskConfig()
        }
        return Singleton.sharedInstance
    }
}
//
//  LoginViewController.swift
//  Pictures
//
//  Created by 廖慶麟 on 2016/1/1.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//


import UIKit
import Parse
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    let installation = PFInstallation.currentInstallation()
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile","email","user_friends"]
        loginButton.center = self.view.center
        loginButton.delegate = self
        
        self.view.addSubview(loginButton)
    }
    
    override func viewDidAppear(animated: Bool) {
        // If logged in then redirect to Main and send FB useremail to backend for setting the IM API
        if FBSDKAccessToken.currentAccessToken() != nil{
            
            self.post(["userEmail":"\(installation["user_id"])","deviceId":UIDevice.currentDevice().identifierForVendor!.UUIDString], url: "https://arcane-coast-26356.herokuapp.com/account/auth")
            
            performSegueWithIdentifier("showMain", sender: self)

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Facebook login
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if error == nil{
            print("Login complete.")
            self.performSegueWithIdentifier("showMain", sender: self)
        }else {
            print(error.localizedDescription)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User logged out...")
    }
    
    func post(params : Dictionary<String,String>, url : String) {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        var err: NSError?
        do{
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions())
        } catch {
            print(err?.localizedDescription)
        }
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            print("Response: \(response)")
            var strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("Body: \(strData)")
            var err: NSError?
            var msg = "No message"
            do{
                var json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // Check and make sure that json has a value using optional binging.
                if let parseJSON = json {
                    // Okay, the parseJSON is here, do something...
                    
                    var session = parseJSON["session"] as? String
                    var userId = parseJSON["userId"] as? String
                    var deviceId = parseJSON["deviceId"] as? String
                    
                    print(session)
                    print(userId)
                    print(deviceId)
                    
                }else{
                    // Woa, the json object was nil, something went wrong. Maybe the server isn't running?
                    let jsonStr = NSString(data: data!,encoding: NSUTF8StringEncoding)
                    print("Error could not parse JSON: \(jsonStr)")
                }
            }catch {
                print(err?.localizedDescription)
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Error could not parse JSON: \(jsonStr)")
            }
        })
        task.resume()
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
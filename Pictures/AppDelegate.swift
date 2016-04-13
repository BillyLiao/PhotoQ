//
//  AppDelegate.swift
//  Pictures
//
//  Created by 廖慶麟 on 2015/12/21.
//  Copyright © 2015年 廖慶麟. All rights reserved.
//

import UIKit
import Parse
import Bolts
import CoreData
import FBSDKCoreKit
import Foundation
import DUMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let firstLaunch = NSUserDefaults.standardUserDefaults().boolForKey("FirstLaunch")
        DUMessaging.setAppId("60a3d6ea8105c9426969fd14a2a38845", appKey:"724b4289d769d4d7df9af5842fa49e5c")

        if #available(iOS 8.0, *) {
            let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            // Fallback on earlier versions
            application.registerForRemoteNotificationTypes([.Alert, .Sound, .Badge])
        }
        
        if firstLaunch {
            print("Not first launch!")
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let viewController: UIViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            self.window?.makeKeyAndVisible()
            self.window?.rootViewController = viewController
        }
        else {
            /* trig by timer through call function inside
            var timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "change_from_tutorial_to_main", userInfo: nil, repeats: true)
            */
            print("First launch, setting NSUserDefault.")
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let tutorialViewController: UIViewController = storyboard.instantiateViewControllerWithIdentifier("TutorialViewController") as! TutorialViewController

            self.window?.makeKeyAndVisible()
            self.window?.rootViewController = tutorialViewController
            
            var answer: Answer!
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "FirstLaunch")
            // Store sample data in answers[0]
            if let managedObjectContext =
                (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
                    answer = NSEntityDescription.insertNewObjectForEntityForName("Answer", inManagedObjectContext: managedObjectContext) as! Answer
                    answer.question = "What's the name of the flower?"
                    answer.answer = "It's a rose. A red rose means love, and a yellow rose means friendship."
                    let questionPhoto1 = UIImage(named: "defaultQuestionPhoto")!
                    let imageData: NSData = UIImagePNGRepresentation(questionPhoto1)!
                    answer.photo = imageData
                    answer.create_time = NSDate()
                    
                    var e: NSError?
                    do {
                        try managedObjectContext.save()
                    } catch {
                        print("Unresolved error \(e), \(e!.userInfo)")
                    }
            }
        }
        
        Parse.enableLocalDatastore()
        
        // Initailize Parse.
        Parse.setApplicationId("TMV1qKmrO5FziiXahM5E4JnTT38VpewRmDtrSPNK", clientKey: "n1xpYKl4A9I8SmaxRaCIQKnrLsSZVy2NdhEBv8MR")
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
    
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // Use this function to inform Parse about this new device.(Callback method)
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.channels = ["global"]
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"name, email"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                let userEmail : NSString = result.valueForKey("email") as! NSString
                installation["user_id"] = userEmail
                let userName : NSString = result.valueForKey("name") as! NSString
                installation.saveInBackground()
            }
        })
    
        installation.saveInBackground()
    }
    
    // Use this function to handle incoming remote notifications while the app is in the foreground.
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        let predicate = NSPredicate(format: "question == %@", userInfo["question"] as! String)
        let fetchRequest = NSFetchRequest(entityName: "Answer")
        fetchRequest.predicate = predicate
        do {
            let fetchedEntities = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Answer]
            fetchedEntities.first!.answer = (userInfo["answer"] as! String)
            // ... Update additional properties with new values
        } catch {
            // Do something in response to error condition
        }
        
        do {
            try self.managedObjectContext.save()
        } catch {
            // Do something in response to error condition
        }
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    /* function be trigged by timer
    func change_from_tutorial_to_main (){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let viewController: UIViewController = storyboard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = viewController
    }
    */

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "csie.CoreData" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Pictures", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Pictures.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
 
    
}


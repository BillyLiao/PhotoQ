//
//  ViewController.swift
//  Pictures
//
//  Created by 廖慶麟 on 2015/12/21.
//  Copyright © 2015年 廖慶麟. All rights reserved.
//

import UIKit
import Parse
import CoreData



class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var uploadActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var uploadMessage: UITextField!
    @IBOutlet weak var ScrollView: UIScrollView!
    var keyboardHeight: CGFloat!
    var image_Already_Picked : Bool!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var testButton: UIButton!
    
    var answer: Answer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        uploadMessage.delegate = self
        
        // Observer of keyboard, we access keyboard height by the observer.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        image_Already_Picked = false
        checkButton.showsTouchWhenHighlighted = true

    }
    
    // seems the best way to move the text field up when keyboard shows.
    func keyboardWillShow(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.CGRectValue()
        ScrollView.setContentOffset(CGPointMake(0, keyboardRectangle.height - 20), animated: true)
        
    }

    /* also can scroll text field, but hard to dynamic access keyboard height.
    func textFieldDidBeginEditing(textField: UITextField) {
    ScrollView.setContentOffset(CGFloatMake(0, 160), animated: true)
    }
    */

    func textFieldDidEndEditing(textField: UITextField) {
        ScrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    // when press return on keyboard, then dismiss it!
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // dismiss the keyboard when touches other place
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicked.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // To change the pivot(image_Already_Picked), so call it by myself.
    @IBAction func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        image_Already_Picked = false
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func imagePick(sender: UITapGestureRecognizer) {
        uploadMessage.resignFirstResponder()

        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        // Create the alert controller
        if #available(iOS 8.0, *) {
            let alertController = UIAlertController(title: "Photo", message: "Which way you want to set your photo?", preferredStyle: .Alert)
            // Create the actions
            let camera = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
                {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                    imagePicker.allowsEditing = true
                    self.image_Already_Picked = true
                    self.presentViewController(imagePicker, animated: true, completion: nil)
                }
            }
            let photoLibrary = UIAlertAction(title: "PhotoLibrary", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum)
                {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                    imagePicker.allowsEditing = false
                    self.image_Already_Picked = true
                    self.presentViewController(imagePicker, animated: true, completion: nil)
                }
            }
            
            let cancel = UIAlertAction(title: "Cancel", style:  UIAlertActionStyle.Cancel) {
                UIAlertAction in
            }
            
            // Add the actions
            alertController.addAction(camera)
            alertController.addAction(photoLibrary)
            alertController.addAction(cancel)
            
            // Present the controller
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
            var pickAlert = UIAlertView()
            pickAlert.delegate = self
            pickAlert.message = "Which way you want to set your photo?"
            pickAlert.addButtonWithTitle("Camera")
            pickAlert.addButtonWithTitle("PhotoLibrary")
            pickAlert.addButtonWithTitle("Cancel")
            pickAlert.title = "Photo"
            pickAlert.show()
            
            
        }
        
        
        
    }
    
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int)
    {
        switch buttonIndex
        {
        case 0:
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
            {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                imagePicker.allowsEditing = true
                self.image_Already_Picked = true
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        case 1:
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum)
            {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                imagePicker.allowsEditing = true
                self.image_Already_Picked = true
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        default:
            NSLog("default")
        }
    }
    @IBAction func uploadButton(sender: AnyObject) {
        
        
        let imageText = uploadMessage.text
        let defaultPhoto = UIImage(named:"defaultPhoto")
        
        let alert = UIAlertView()
        alert.title = "Alert"
        alert.message = "Can't upload empty photo(question)."
        alert.addButtonWithTitle("Roger that.")
        
        let notice = UIAlertView()
        notice.title = "We got your questions!"
        notice.message = "You will receive your answer in a couple of minutes."
        notice.addButtonWithTitle("Thank you~")

       
        
        
        if image_Already_Picked == false || uploadMessage.text == "" {
                alert.show()
            }else{
                uploadActivityIndicator.startAnimating()
                uploadButton.enabled = false
                checkButton.enabled = false
                imagePicked.userInteractionEnabled = false
                uploadMessage.enabled = false
                let posts = PFObject(className: "Posts")
                let installation = PFInstallation.currentInstallation()

                posts["imageText"] = imageText
                // set a column to response by backend.
                posts["imageAnswer"] = ""
                posts["user_id"] = installation["user_id"]
                posts.saveInBackgroundWithBlock({
                    (success: Bool, error: NSError?) -> Void in
                    if error == nil{
                        /* success saving,Now save image.*/
                        //Create an image data.
                        
                        //PNGRepresentation need fixing orientation.
                        let imageData = UIImageJPEGRepresentation(self.imagePicked.image!,0.3)
                        //create a parse file to store in cloud
                        let parseImageFile = PFFile(name: "uploaded_image.jpg", data: imageData!)
                        posts["imageFile"] = parseImageFile

                        
                        posts.saveInBackgroundWithBlock({
                            (success: Bool,error: NSError?) -> Void in
                            if error == nil{
                                //take user home

                                notice.show()
                                let delay = 3.0 * Double(NSEC_PER_SEC)
                                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                                dispatch_after(time, dispatch_get_main_queue(), {
                                    notice.dismissWithClickedButtonIndex(-1, animated: true)
                                })

                                print("Data uploaded")
                                
                                var answer: Answer!
                                if let managedObjectContext =
                                    (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
                                        answer = NSEntityDescription.insertNewObjectForEntityForName("Answer", inManagedObjectContext: managedObjectContext) as! Answer
                                        answer.question = imageText
                                        answer.photo = UIImageJPEGRepresentation(self.imagePicked.image!,0.3)
                                        answer.create_time = NSDate()
                        
                                        var e: NSError?
                                        do {
                                            try managedObjectContext.save()
                                            self.uploadActivityIndicator.stopAnimating()
                                            self.image_Already_Picked = false
                                            self.uploadButton.enabled = true
                                            self.checkButton.enabled = true
                                            self.imagePicked.userInteractionEnabled = true
                                            self.uploadMessage.enabled = true
                                        } catch {
                                            print("Unresolved error \(e), \(e!.userInfo)")
                                        }
                                        
                                }
                                
                                self.uploadMessage.text = nil
                                self.imagePicked.image = defaultPhoto
                                
                            }else{
                                print(error)
                            }
                        })
                        
                    }else{
                        print(error)
                    }
                })
            }
        
       
    }
   
    @IBAction func testButton(sender: AnyObject) {
        let installation = PFInstallation.currentInstallation()
        self.post(["useremail":"\(installation["user_id"])","userdeviceid":UIDevice.currentDevice().identifierForVendor!.UUIDString
], url: "https://arcane-coast-26356.herokuapp.com/session/create")
        
    }
    
    func post(params : Dictionary<String,String>, url : String) {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var err: NSError?
        do{
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions())
        } catch {
            print(err?.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if (error != nil){
                print(error?.localizedDescription)
            }
            print("haha")
        })
        task.resume()
    }

}


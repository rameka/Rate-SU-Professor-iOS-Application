//
//  UserLoginController.swift
//  RateSUProfessor
//
//  Created by Jegan Gopalakrishnan on 4/21/17.
//  Copyright © 2017 Syracuse University. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FirebaseDatabase
import FirebaseAuth

class UserLoginController : UIViewController, FBSDKLoginButtonDelegate, UITextFieldDelegate {

    @IBOutlet weak var emailId: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var loginView: FBSDKLoginButton!
    
   
    
    // IBAction for Login method
    @IBAction func login ()
    {
        FIRAuth.auth()?.signInWithEmail(emailId.text!, password: Password.text!, completion: {
            user, error in
            if ( error != nil )
            {
                // Error Handling for all possible error codes
                if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                    
                    print(errCode)
                    
                    switch errCode {
                    
                    case .ErrorCodeInvalidEmail:
                        print("Invalid email Address")
                        self.displayMyAlertMessage("Invalid email ID")
                    case .ErrorCodeWrongPassword:
                        if(self.emailId.text! == "" && self.Password.text! == "")
                        {
                            self.displayMyAlertMessage("OOPS !! You forgot to enter username and password")
                        }
                        else if(self.emailId.text! == "")
                        {
                            self.displayMyAlertMessage("OOPS !! You forgot to enter emailID")
                        }
                        else if(self.Password.text! == "")
                        {
                            self.displayMyAlertMessage("OOPS !! You forgot to enter password")
                        }
                        else
                        {
                            print("Wrong Password")
                            self.displayMyAlertMessage("Wrong Password")
                        }
                    case .ErrorCodeUserNotFound:
                        self.displayMyAlertMessage("Please Sign UP first!!!")
                    default:
                        self.displayMyAlertMessage("Unknown Error !! Please try after some time")
                    }
                }
                print("Incorrect Login Information")
            }
            else{
                // Update the professor and user information from Firebase DB
                print("User Logged In Successfully")
                DatabaseController.userProfile.emailId = self.emailId.text!
                DatabaseController.updateDB()
                Model.updateDB()
                
                // Take the user to the main screen of the application
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("MainScreen") as! MainScreenViewController
                self.presentViewController(nextViewController, animated:true, completion:nil)
            }
        })
    }
    
    // To display alert message when user sign in with invalid username or password
    func displayMyAlertMessage(userMessage:String)
    {
        
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.Default, handler:nil);
        myAlert.addAction(okAction);
        
        self.presentViewController(myAlert, animated:true, completion:nil);
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginView.delegate = self
        loginView.readPermissions = ["public_profile", "email", "user_friends"]
    }
    
    // Facebook Login Action
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // No action needed in this phase of project
        }
        else if result.isCancelled {
            // No action needed in this phase of project
        }
        else {
            // Update user profile
            Model.updateDB()

            let accessToken = FBSDKAccessToken.currentAccessToken()
            
            let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: accessToken.tokenString, version: nil, HTTPMethod: "GET")
            req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
                if(error == nil)
                {
                    DatabaseController.createProfile(result["name"] as! String, university: nil, yearOfGraduation: nil, major: nil, emailId: result["email"] as! String)
                    print("result \(result)")
                }
                else
                {
                    print("error \(error)")
                }
            })
            
            // Goto the main screen of application
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("MainScreen") as! MainScreenViewController
            self.presentViewController(nextViewController, animated:true, completion:nil)
        }
    }
    
    // Method Invoked when facebook logs out
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    // Manually logout when user uses our button instead of FB button
    static func facebookLogout() {
        FBSDKLoginManager().logOut()
    }
   
    
    // Hides keyboard when user taps the background
    @IBAction func userTappedBackground( gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }

}



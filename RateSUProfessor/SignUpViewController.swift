//
//  SignUpViewController.swift
//  RateSUProfessor
//
//  Created by Jegan Gopalakrishnan on 4/21/17.
//  Copyright © 2017 Syracuse University. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class SignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var emailId: UITextField!
    
    
    // SignUP IBAction - Creates an account in FireBase Authentication
    @IBAction func CreateAccount(sender: AnyObject) {
        
        FIRAuth.auth()?.createUserWithEmail(emailId.text! , password: Password.text!, completion: { user, error in
            
            // Handling all error scenarios in SignUP cases
            if error != nil {
                
                print(error)
                
                if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                    
                    print(errCode)
                    
                    switch errCode {
                        
                    case .ErrorCodeInvalidEmail:
                        print("Invalid email Address")
                        self.displayMyAlertMessage("Invalid email ID", status: 2)
                    case .ErrorCodeEmailAlreadyInUse:
                        self.displayMyAlertMessage("email ID already registered", status: 1)
                    case .ErrorCodeWeakPassword:
                        if(self.Username.text! == "" && self.emailId.text! == "" && self.Password.text! == "")
                        {
                            self.displayMyAlertMessage("OOPS !! You forgot to enter username, emailID and password", status: 2)
                        }
                        else if(self.Username.text! == "" || self.emailId.text! == "" || self.Password.text! == "")
                        {
                            self.displayMyAlertMessage("OOPS !! You forgot to enter all fields", status: 2)
                        }
                        else
                        {
                            self.displayMyAlertMessage("OOPS !! Your Password is weak. Password should be atleast 6 characters", status:2)
                        }
                    default:
                        self.displayMyAlertMessage("Unknown Error !! Please try after some time", status: 2)
                    }
                }

                
            }
            else
            {
                // Add the user info the DB and take you to login screen
                print("User Created")
                
                DatabaseController.createProfile(self.Username.text!, university: nil, yearOfGraduation: nil, major: nil, emailId: self.emailId.text!)
                Model.updateDB()
                                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("UserLoginView") as! UserLoginController
                self.presentViewController(nextViewController, animated:true, completion:nil)
            }
        })
        
    }

    
    // To display alert message when user sign in with invalid username or password
    func displayMyAlertMessage(userMessage:String, status: Int )
    {
        
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        var okAction : UIAlertAction!
        if ( status == 1)
        {
            okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.Default, handler:returnToMainView)
        }
        else
        {
            okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.Default, handler:nil)
        }
        myAlert.addAction(okAction);
        
        self.presentViewController(myAlert, animated:true, completion:nil);
        
    }
    
    // Handler takes you to login screen
    func returnToMainView (alert: UIAlertAction!) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("UserLoginView") as! UserLoginController
        self.presentViewController(nextViewController, animated:true, completion:nil)
    }
    
    
    // Hides keyboard when user taps the background
    @IBAction func userTappedBackground( gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
}

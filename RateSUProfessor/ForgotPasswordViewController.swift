//
//  ForgotPasswordViewController.swift
//  RateSUProfessor
//
//  Created by Jegan Gopalakrishnan on 4/22/17.
//  Copyright © 2017 Syracuse University. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ForgotPasswordViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailId: UITextField!
    
    @IBAction func sendPasswordReset(sender: AnyObject) {
        

        
        FIRAuth.auth()?.sendPasswordResetWithEmail(emailId.text!, completion: { (error) in
            if (error == nil )
            {
                self.displayMyAlertMessage("Password reset mail sent successfully", status: 1)
            }
            else
            {
                print(error)
                if let errCode = FIRAuthErrorCode(rawValue: (error?._code)!) {
                    switch errCode {
                    case .ErrorCodeInvalidEmail:
                        self.displayMyAlertMessage("Invalid email address", status: 0)
                    case .ErrorCodeUserNotFound:
                        self.displayMyAlertMessage("User not found !! Please Sign Up", status: 2)
                    case .ErrorCodeInternalError:
                        self.displayMyAlertMessage("OOPS !! You forgot to enter an email ID", status: 0)
                    default:
                        self.displayMyAlertMessage("Unknown error !! Please try after some time", status: 0)

                    }
                }
                        
            }
        })
        
    }
    
    func displayMyAlertMessage(userMessage:String, status: Int )
    {
        
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        var okAction : UIAlertAction!
        if ( status == 1)
        {
            okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.Default, handler:returnToMainView)
        }
        else if (status == 2 )
        {
            okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.Default, handler:returnToSignUpView)
        }
        else
        {
            okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.Default, handler:nil)
        }
        myAlert.addAction(okAction);
        
        self.presentViewController(myAlert, animated:true, completion:nil);
        
    }
    
    func returnToMainView (alert: UIAlertAction!) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("UserLoginView") as! UserLoginController
        self.presentViewController(nextViewController, animated:true, completion:nil)
    }
    
    func returnToSignUpView (alert: UIAlertAction!) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("SignUpViewController") as! SignUpViewController
        self.presentViewController(nextViewController, animated:true, completion:nil)
    }
    
    
    // Hides keyboard when user taps the background
    @IBAction func userTappedBackground( gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
}

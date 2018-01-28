//
//  ProfileCustomCell.swift
//  RateSUProfessor
//
//  Created by Jegan Gopalakrishnan on 4/23/17.
//  Copyright © 2017 Syracuse University. All rights reserved.
//

import UIKit

class ProfileCustomCell : UITableViewCell {
    
    @IBOutlet weak var Button: UIButton!
    @IBOutlet weak var TextField: UITextField!
    
    var sectionIndex : Int!
    
    // Enables editing function of the label
    @IBAction func ButtonPressed(sender: UIButton) {
        

        if(sender.titleLabel?.text == "Edit")
        {
            
            Button.setTitle("Done", forState: .Normal)
            Button.setTitleColor(UIColor.blueColor(), forState: .Normal)
            TextField.enabled = true
            TextField.becomeFirstResponder()
            
        }
        else
        {
            Button.setTitle("Edit", forState: .Normal)
            Button.setTitleColor(UIColor.orangeColor(), forState: .Normal)
            TextField.enabled = false
            if let value = TextField.text {
                
            
            switch sectionIndex {
                
            case 0:
                DatabaseController.updateName(value)
            case 1:
                DatabaseController.updateUniversity(value)
            case 2:
                DatabaseController.updateYearOfGraduation(value)
            case 3:
                DatabaseController.updateMajor(value)
            default:
                print("ERROR : [ProfileCustomCell> ButtonPressed] : Invalid Section Index")
            }
            }
            else
            {
                TextField.text = "NA"
            }
            
        }
        
    }
    
    
}


class SectionHeaderCell : UITableViewCell {
    
    @IBOutlet weak var Label: UILabel!
   
    
    
    
}

class LastCell : UITableViewCell {
    
    @IBOutlet weak var Button: UIButton!
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    // user can logout of the application when this button is clicked
    @IBAction func LogOut(sender: AnyObject) {
        
        UserLoginController.facebookLogout()
    }
    
}
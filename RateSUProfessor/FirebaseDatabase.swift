//
//  FirebaseDatabase.swift
//  RateSUProfessor
//
//  Created by Jegan Gopalakrishnan on 4/23/17.
//  Copyright © 2017 Syracuse University. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

struct UserProfile {
    var name = "anonymous"
    var university = "nil"
    var yearOfGraduation = "nil"
    var major = "nil"
    var emailId = "nil"
    var username : String {
        return emailId.stringByReplacingOccurrencesOfString(".", withString: "-")
    }
}

class DatabaseController {
    
    static var userProfile = UserProfile()
    
    static func createProfile(name: String, university: String?, yearOfGraduation: Int?, major: String?, emailId: String) {
        
        let ref = FIRDatabase.database().reference()
        
        var profile : [String : AnyObject] = ["name" : name, "emailId" : emailId]
        userProfile.name = name
        userProfile.emailId = emailId
        ref.child("UserProfile").observeSingleEventOfType(.Value, withBlock: {snapshot in
            
            if snapshot.hasChild(self.userProfile.username){
                
                print("DB Exists")
                
            }
            else
            {
                
                
                if let value = university {
                    profile["university"] = value
                    userProfile.university = value
                }
                else {
                    profile["university"] = "NA"
                    userProfile.university = "NA"
                }
                
                if let value = yearOfGraduation {
                    profile["yearOfGraduation"] = String(value)
                    userProfile.yearOfGraduation = String(value)
                }
                else {
                    profile["yearOfGraduation"] = "NA"
                    userProfile.yearOfGraduation = "NA"
                }
                
                if let value = major {
                    profile["major"] = value
                    userProfile.major = value
                }
                else {
                    profile["major"] = "NA"
                    userProfile.major = "NA"
                }
                
                
                ref.child("UserProfile").child(userProfile.username).setValue(profile)
            }
            
            self.setCallBackForDBSync()
        
        })
        
        

        
    }
    
    static func setCallBackForDBSync(){
        
        let ref = FIRDatabase.database().reference()
        
        ref.child("UserProfile").child(userProfile.username).observeEventType(FIRDataEventType.Value,withBlock:  {snapshot in
            self.userProfile.name = snapshot.value!["name"] as! String
            self.userProfile.university = snapshot.value!["university"] as! String
            self.userProfile.yearOfGraduation = snapshot.value!["yearOfGraduation"] as! String
            self.userProfile.major = snapshot.value!["major"] as! String
            print("DB Updated")
            self.printUpdatedDB()
            
        })
        
        
        ref.child("UserProfile/\(userProfile.username)/emailId").setValue(userProfile.emailId)
    
    }
    
    static func updateDB() {
        
        let ref = FIRDatabase.database().reference()
        ref.child("UserProfile").child(userProfile.username).observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if !snapshot.exists() { return }
            
            
            self.userProfile.name = snapshot.value!["name"] as! String
            self.userProfile.university = snapshot.value!["university"] as! String
            self.userProfile.yearOfGraduation = snapshot.value!["yearOfGraduation"] as! String
            self.userProfile.major = snapshot.value!["major"] as! String
            
            self.printUpdatedDB()
        })
    }
    
    static func printUpdatedDB(){
        print(" Name : \(userProfile.name)")
        print(" University : \(userProfile.university)")
        print(" YearOfGraduation : \(userProfile.yearOfGraduation)")
        print(" Major : \(userProfile.major)")
        print(" Email ID: \(userProfile.emailId)")
    }
    
    static func updateName(name: String) {
        let ref = FIRDatabase.database().reference()
        ref.child("UserProfile/\(userProfile.username)/name").setValue(name)
    }
    
    static func updateUniversity(university: String) {
        let ref = FIRDatabase.database().reference()
        ref.child("UserProfile/\(userProfile.username)/university").setValue(university)
    }
    
    static func updateYearOfGraduation(yearOfGraduation: String) {
        let ref = FIRDatabase.database().reference()
        ref.child("UserProfile/\(userProfile.username)/yearOfGraduation").setValue(yearOfGraduation)
    }
    
    static func updateMajor(major: String) {
        let ref = FIRDatabase.database().reference()
        ref.child("UserProfile/\(userProfile.username)/major").setValue(major)
    }
    

}

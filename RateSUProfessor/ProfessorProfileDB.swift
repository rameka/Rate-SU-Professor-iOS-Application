//
//  ProfessorProfileDB.swift
//  RateSUProfessor
//
//  Created by Jegan Gopalakrishnan on 4/30/17.
//  Copyright © 2017 Syracuse University. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

struct ratingStructure {
    var comment : String
    var commentTitle : String
    var courseName : String
    var courseNumber : String
    var difficultyLevel : String
    var ratingValue : String
}

struct ProfessorProfileStructure {
    var currentResearch : String
    var degree : String
    var department : String
    var email : String
    var jobPosition : String
    var name : String
    var phone : String
    var publications : String
    var researchInterest : String
    var teachingInterest : String
    var staffRoom : String
    var averageRating : Float
    var averageDifficulty: Float
    var ratings : [ratingStructure]
}

class profDB {
    static var profile = [ProfessorProfileStructure]()
    
    static var profileIndex : [String : Int] = ["kdcadwel@syr-edu" : 0, "rchen02@syr-edu" : 1, "jfawcett@twcny-rr-com" : 2,
                                                "blair@ecs-syr-edu" : 3, "wedu@syr-edu" : 4, "alee18@syr-edu" : 5]
    
    static func updateChemistryProfessor(){
        
        let ref = FIRDatabase.database().reference()
        
        for iter in 0 ..< ProfessorUserID.profChemicalEngineering.count {
            ref.child("Professor").child("Department").child("ChemicalEngineering").child(ProfessorUserID.profChemicalEngineering[iter]).observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                if !snapshot.exists() { return }
                
                print(snapshot)
                let currentResearch = snapshot.value!["CurrentResearch"] as! String
                let degree = snapshot.value!["Degree"] as! String
                let department = snapshot.value!["Department"] as! String
                let email = snapshot.value!["Email"] as! String
                let jobPosition = snapshot.value!["JobPosition"] as! String
                let name = snapshot.value!["Name"] as! String
                let phone = snapshot.value!["Phone"] as! String
                let publications = snapshot.value!["Publications"] as! String
                let researchInterest = snapshot.value!["ResearchInterest"] as! String
                let teachingInterest = snapshot.value!["TeachingInterest"] as! String
                let staffRoom = snapshot.value!["StaffRoom"] as! String
                let averageRating = snapshot.value!["AverageRating"] as! Float
                let averageDifficulty = snapshot.value!["AverageDifficulty"] as! Float
                let ratings = [ratingStructure]()
                
                self.profile.insert(ProfessorProfileStructure(currentResearch: currentResearch, degree: degree, department: department, email: email, jobPosition: jobPosition, name: name, phone: phone, publications: publications, researchInterest: researchInterest, teachingInterest: teachingInterest, staffRoom: staffRoom, averageRating: averageRating,averageDifficulty: averageDifficulty, ratings:  ratings),atIndex : iter)
                
                if(iter == 1)
                {
                    self.updateChemistryRatings()
                    self.updateChemistryProfessorRatingsOnEvent()
                    self.updateComputerProfessorProfile()
                }
            })
        }

        
    }
    
    static func updateChemistryRatings()
    {
        let ref = FIRDatabase.database().reference()
        for iter in 0 ..< ProfessorUserID.profChemicalEngineering.count {
            ref.child("Professor").child("Department").child("ChemicalEngineering").child(ProfessorUserID.profChemicalEngineering[iter]).observeEventType(.Value, withBlock: { snapshot in
                
                if !snapshot.exists() { return }
                
                
                let averageRating = snapshot.value!["AverageRating"] as! Float
                
                self.profile[iter].averageRating = averageRating
                self.profile[iter].averageDifficulty = snapshot.value!["AverageDifficulty"] as! Float
            })
        }

    }
    
    
    static func updateChemistryProfessorRatingSingleEvent () {
        
        let ref = FIRDatabase.database().reference()
        for iter in 0 ..< ProfessorUserID.profChemicalEngineering.count {
            ref.child("Professor").child("Department").child("ChemicalEngineering").child(ProfessorUserID.profChemicalEngineering[iter]).child("Ratings").observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                if !snapshot.exists() { return }
                    
                    if let rating = snapshot.value as? [String:AnyObject]{
                        
                        for each in rating as [String: AnyObject] {
                            
                            let autoID = each.0
                            //Here you retrieve your autoID
                            
                            ref.child("Professor").child("Department").child("ChemicalEngineering").child(ProfessorUserID.profChemicalEngineering[iter]).child("Ratings").child(autoID).observeEventType(.Value, withBlock: {(ratingSnap) in
                                
                                let commentTitle = ratingSnap.value!["CommentTitle"] as! String
                                let courseName = ratingSnap.value!["CourseName"] as! String
                                let courseNumber = ratingSnap.value!["CourseNumber"] as! String
                                let difficultyLevel = ratingSnap.value!["DifficultyValue"] as! String
                                let ratingValue = ratingSnap.value!["RatingValue"] as! String
                                let comment = ratingSnap.value!["Comment"] as! String
                                
                                
                                self.profile[iter].ratings.append(ratingStructure(comment: comment, commentTitle: commentTitle, courseName:courseName, courseNumber: courseNumber, difficultyLevel: difficultyLevel, ratingValue: ratingValue))
                                
                                if(iter == 1)
                                {
                                    self.updateChemistryProfessorRatingsOnEvent()
                                }
                            })
                        }
                    }
                })
        }

    }
    
    static func updateChemistryProfessorRatingsOnEvent()
    {
        let ref = FIRDatabase.database().reference()
        
        for iter in 0 ..< ProfessorUserID.profChemicalEngineering.count {
            ref.child("Professor").child("Department").child("ChemicalEngineering").child(ProfessorUserID.profChemicalEngineering[iter]).child("Ratings").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: { snapshot in
                
                if !snapshot.exists() { return }
                
                let comment = snapshot.value!["Comment"] as! String
                let commentTitle = snapshot.value!["CommentTitle"] as! String
                let courseName = snapshot.value!["CourseName"] as! String
                let courseNumber = snapshot.value!["CourseNumber"] as! String
                let difficultyLevel = snapshot.value!["DifficultyValue"] as! String
                let ratingValue = snapshot.value!["RatingValue"] as! String
                
                self.profile[iter].ratings.append(ratingStructure(comment: comment, commentTitle: commentTitle, courseName:courseName, courseNumber: courseNumber, difficultyLevel: difficultyLevel, ratingValue: ratingValue))
            })
        }

    }
    
    static func updateProfessorProfile()
    {
        
        updateChemistryProfessor()
      

    }

    static func updateComputerProfessorProfile()
    {
        let ref = FIRDatabase.database().reference()
        for iter in 0 ..< ProfessorUserID.profComputerScience.count {
            ref.child("Professor").child("Department").child("ComputerScience").child(ProfessorUserID.profComputerScience[iter]).observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                if !snapshot.exists() { return }
                
                let currentResearch = snapshot.value!["CurrentResearch"] as! String
                let degree = snapshot.value!["Degree"] as! String
                let department = snapshot.value!["Department"] as! String
                let email = snapshot.value!["Email"] as! String
                let jobPosition = snapshot.value!["JobPosition"] as! String
                let name = snapshot.value!["Name"] as! String
                let phone = snapshot.value!["Phone"] as! String
                let publications = snapshot.value!["Publications"] as! String
                let researchInterest = snapshot.value!["ResearchInterest"] as! String
                let teachingInterest = snapshot.value!["TeachingInterest"] as! String
                let staffRoom = snapshot.value!["StaffRoom"] as! String
                let averageRating = snapshot.value!["AverageRating"] as! Float
                let averageDifficulty = snapshot.value!["AverageDifficulty"] as! Float
                let ratings = [ratingStructure]()
                
                self.profile.append(ProfessorProfileStructure(currentResearch: currentResearch, degree: degree, department: department, email: email, jobPosition: jobPosition, name: name, phone: phone, publications: publications, researchInterest: researchInterest, teachingInterest: teachingInterest, staffRoom: staffRoom, averageRating: averageRating, averageDifficulty: averageDifficulty, ratings:  ratings))
                
                if(iter == 3)
                {
                    self.updateComputerProfessorRatings()
                    self.updateComputerProfessorRatingsOnEvent ()
                }
            })
        }
        
        
        
    }
    
    static func updateComputerProfessorRatings(){
    
    let ref = FIRDatabase.database().reference()
        for iter in 0 ..< ProfessorUserID.profComputerScience.count {
            ref.child("Professor").child("Department").child("ComputerScience").child(ProfessorUserID.profComputerScience[iter]).observeEventType(.Value, withBlock: { snapshot in
                
                if !snapshot.exists() { return }
                
                self.profile[iter+2].averageRating = snapshot.value!["AverageRating"] as! Float
                self.profile[iter+2].averageDifficulty = snapshot.value!["AverageDifficulty"] as! Float
                
            })
        }
    }
        
//    static func updateComputerProfessorRatingsSingleEvent()
//    {
//        let ref = FIRDatabase.database().reference()
//        for iter in 0 ..< ProfessorUserID.profComputerScience.count {
//            ref.child("Professor").child("Department").child("ComputerScience").child(ProfessorUserID.profComputerScience[iter]).child("Ratings").queryOrderedByKey().observeSingleEventOfType(.Value, withBlock: { snapshot in
//                if !snapshot.exists() { return }
//                
//                if let rating = snapshot.value as? [String:AnyObject]{
//                    
//                    for each in rating as [String: AnyObject] {
//                        
//                        let autoID = each.0
//                        //Here you retrieve your autoID
//                        
//                        ref.child("Professor").child("Department").child("ComputerScience").child(ProfessorUserID.profComputerScience[iter]).child("Ratings").child(autoID).observeEventType(.Value, withBlock: {(ratingSnap) in
//                            
//                            let commentTitle = "updateComputerProfessorRatingsSingleEvent"//ratingSnap.value!["CommentTitle"] as! String
//                            let courseName = ratingSnap.value!["CourseName"] as! String
//                            let courseNumber = ratingSnap.value!["CourseNumber"] as! String
//                            let difficultyLevel = ratingSnap.value!["DifficultyValue"] as! String
//                            let ratingValue = ratingSnap.value!["RatingValue"] as! String
//                            let comment = ratingSnap.value!["Comment"] as! String
//                            
//                            
//                            self.profile[iter+2].ratings.append(ratingStructure(comment: comment, commentTitle: commentTitle, courseName:courseName, courseNumber: courseNumber, difficultyLevel: difficultyLevel, ratingValue: ratingValue))
//                            
//                            if(iter == 2) {
//                                
//                                self.updateComputerProfessorRatingsOnEvent()
//                            }
//                        })
//                    }
//                }
//            })
//        }
//    }
    
    
    static func updateComputerProfessorRatingsOnEvent()
    {
        let ref = FIRDatabase.database().reference()
        for iter in 0 ..< ProfessorUserID.profComputerScience.count {
            ref.child("Professor").child("Department").child("ComputerScience").child(ProfessorUserID.profComputerScience[iter]).child("Ratings").observeEventType(.ChildAdded, withBlock: { snapshot in
                
                if !snapshot.exists() { return }
                
                let comment = snapshot.value!["Comment"] as! String
                let commentTitle = snapshot.value!["CommentTitle"] as! String
                let courseName = snapshot.value!["CourseName"] as! String
                let courseNumber = snapshot.value!["CourseNumber"] as! String
                let difficultyLevel = snapshot.value!["DifficultyValue"] as! String
                let ratingValue = snapshot.value!["RatingValue"] as! String
                
                //print("\(snapshot.childrenCount)")
                
                
                print("Updated \(ProfessorUserID.profComputerScience[iter]) added event")
                
                self.profile[iter+2].ratings.insert(ratingStructure(comment: comment, commentTitle: commentTitle, courseName:courseName, courseNumber: courseNumber, difficultyLevel: difficultyLevel, ratingValue: ratingValue),atIndex: 0)
            })
        }
    }
}

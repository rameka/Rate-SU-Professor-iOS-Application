//
//  Model.swift
//  
//
//  Created by Ramakrishna Sayee on 4/19/17.
//  Copyright © 2017 Syracuse University. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class ProfessorUserID {
    static var profChemicalEngineering = ["kdcadwel@syr-edu", "rchen02@syr-edu"]
    static var profComputerScience = ["jfawcett@twcny-rr-com", "blair@ecs-syr-edu", "wedu@syr-edu", "alee18@syr-edu"]
}

class TableViewCellData {
    
    var imageName: String!
    var profName: String!
    var profDepartment:String!
    var profDesignation: String!
    var currentResearch:String!
    var publications:String!
    var avgRating:Float!
    var avgDifficulty:Float!
    var profEmail:String!
    var profPhoneNumber:String!
    var profDegree:String!
    var researchInterests: String!
    var teachingInterests: String!
    var staffRoom: String!
    
    
    init (imgName:String, profName:String, profDepartment:String, profDesignation: String!, currentResearch: String!,
          publications: String!, avgRating: Float!, avgDifficulty:Float!, profEmail:String!, profPhoneNumber: String!,
          profDegree:String!, researchInterests: String!, teachingInterests:String!, staffRoom: String!)
    {
        self.imageName = imgName
        self.profName = profName
        self.profDepartment = profDepartment
        self.profDesignation = profDesignation
        self.currentResearch = currentResearch
        self.publications = publications
        self.avgRating = avgRating
        self.avgDifficulty = avgDifficulty
        self.profEmail = profEmail
        self.profPhoneNumber = profPhoneNumber
        self.profDegree = profDegree
        self.researchInterests = researchInterests
        self.teachingInterests = teachingInterests
        self.staffRoom = staffRoom
    }

    
}

class CurrentProfessor {
    static var imageName: String!
    static var profName: String!
    static var departmentName: String!
    static var currentResearch:String!
    static var publications:String!
    static var avgRating:Float!
    static var avgDifficulty:Float!
    static var profEmail:String!
    static var profPhoneNumber:String!
    static var profDegree:String!
    static var researchInterests: String!
    static var teachingInterests: String!
    static var staffRoom: String!
}

class Model:NSObject{
    
    
    static var cellArray = [TableViewCellData]()
    static var value = true
    
    static func updateDB()
    {
        
        for iter in 0..<(ProfessorUserID.profChemicalEngineering.count + ProfessorUserID.profComputerScience.count) {
            
            if (value)
            {
                var department = "Chemical Engineering"
                if (iter > 1)
                {
                    department = "Computer Science"
                }
            
                cellArray.append(TableViewCellData(imgName: profDB.profile[iter].email.stringByReplacingOccurrencesOfString(".", withString: "-"), profName: profDB.profile[iter].name, profDepartment: department,profDesignation: profDB.profile[iter].jobPosition,currentResearch: profDB.profile[iter].currentResearch,publications: profDB.profile[iter].publications,avgRating: profDB.profile[iter].averageRating,avgDifficulty: profDB.profile[iter].averageDifficulty,profEmail: profDB.profile[iter].email, profPhoneNumber: profDB.profile[iter].phone,profDegree: profDB.profile[iter].degree,researchInterests: profDB.profile[iter].researchInterest,teachingInterests: profDB.profile[iter].teachingInterest,staffRoom: profDB.profile[iter].staffRoom))
                
                if(iter == 5)
                {
                    value = false
                }
            }
            else
            {
                for iter in 0..<(ProfessorUserID.profChemicalEngineering.count + ProfessorUserID.profComputerScience.count) {
                    cellArray[iter].avgRating = profDB.profile[iter].averageRating
                    cellArray[iter].avgDifficulty = profDB.profile[iter].averageDifficulty
                }
                
            }
        
        }
    }
    // returns the array populated with professor content to display in explore view
    class func generateArray() ->[TableViewCellData]{
        return cellArray
    }
}

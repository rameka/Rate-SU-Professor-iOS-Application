//
//  RateViewController.swift
//  Practice
//
//  Created by Ramakrishna Sayee on 4/23/17.
//  Copyright © 2017 Syracuse University. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class RateViewController:UIViewController,UITextViewDelegate{
    
    struct Review{
        
        var courseNumber:String? = nil
        var courseName:String? = nil
        var difficultValue:String? = nil
        var ratingValue:String? = nil
        var commentTitle:String? = nil
        var comment:String? = nil
        
    }
    
    var commentTextchanged = false
    var commentTitleChanged = false
    var review = Review()
    
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var courseNumber: UITextField!
    @IBOutlet weak var courseName: UITextField!
    
    @IBOutlet weak var rateSlider: UISlider!
    @IBOutlet weak var difficultSlider: UISlider!
    
    @IBOutlet weak var rateValue: UILabel!
    @IBOutlet weak var difficultValue: UILabel!
    
    @IBOutlet weak var commentTitle: UITextView!
    @IBOutlet weak var comment: UITextView!
    
    @IBOutlet weak var image1: UIImageView!
    
    @IBOutlet weak var image2: UIImageView!
    
    @IBOutlet weak var image3: UIImageView!
    
    @IBOutlet weak var image4: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        submit.backgroundColor=UIColor.clearColor()
        submit.layer.backgroundColor = UIColor.whiteColor().CGColor
        submit.layer.borderWidth = 1
        submit.layer.borderColor = UIColor.darkGrayColor().CGColor
        submit.layer.shadowColor = UIColor.blackColor().CGColor
        submit.layer.shadowOpacity = 0.8
        submit.layer.shadowOffset = CGSizeMake(0, 0)
        submit.layer.masksToBounds = false
        submit.layer.cornerRadius = 5
        
        
        image1.layer.shadowColor = UIColor.blackColor().CGColor
        image1.layer.shadowOpacity = 0.8
        image1.layer.shadowOffset = CGSizeMake(0, 0)
        image1.layer.masksToBounds = false
        image1.clipsToBounds = false
        
        image2.layer.shadowColor = UIColor.blackColor().CGColor
        image2.layer.shadowOpacity = 0.8
        image2.layer.shadowOffset = CGSizeMake(0, 0)
        image2.layer.masksToBounds = false
        image2.clipsToBounds = false
        
        image3.layer.shadowColor = UIColor.blackColor().CGColor
        image3.layer.shadowOpacity = 0.8
        image3.layer.shadowOffset = CGSizeMake(0, 0)
        image3.layer.masksToBounds = false
        image3.clipsToBounds = false
        
        image4.layer.shadowColor = UIColor.blackColor().CGColor
        image4.layer.shadowOpacity = 0.8
        image4.layer.shadowOffset = CGSizeMake(0, 0)
        image4.layer.masksToBounds = false
        image4.clipsToBounds = false
        
        comment.delegate = self
        commentTitle.delegate = self
        
        
        commentTitle.text = "Describe in single Line!"
        commentTitle.textColor = UIColor.lightGrayColor()
        
        comment.text = "Please enter your comments here"
        comment.textColor = UIColor.lightGrayColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        rateValue.text = String(Int(rateSlider.value))
        difficultValue.text = String(Int(difficultSlider.value))
        
    }
    //setting the slider value to laber for rating
    @IBAction func rateSliderChanged(sender: UISlider) {
        
        rateValue.text = String(Int(sender.value))
        
    }
    //setting the difficult slider value on slider input dynamically
    @IBAction func difficultSliderChanged(sender: UISlider) {
        
        difficultValue.text = String(Int(sender.value))
    }
    // function for setting the place holder
    func textViewDidBeginEditing(textView: UITextView) {
        if(textView.text == comment.text){
            commentTextchanged = true
        }
        if (textView.text == commentTitle.text){
            commentTitleChanged = true
        }
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }

    }
    // action invoked when submit button is clicked
    @IBAction func submitReview(sender: UIButton) {
        
        var flag = 1
        var post = [String : AnyObject]()
        
        if let cnumber = courseNumber.text{
            review.courseNumber = cnumber
            print(review.courseNumber)
            post ["CourseNumber"] = review.courseNumber!
        }
        
        if let cname = courseName.text {
            review.courseName = cname
            print(review.courseName)
            post["CourseName"] = review.courseName!
        }
        
        if let rvalue = rateValue.text{
            review.ratingValue = rvalue
            print(review.ratingValue)
            post["RatingValue"] = review.ratingValue!
        }
        
        if let dvalue = difficultValue.text{
            review.difficultValue = dvalue
            print(review.difficultValue)
            post["DifficultyValue"] = review.difficultValue!
        }
        
        if let ctitle = commentTitle.text{
            review.commentTitle = ctitle
            print(review.commentTitle)
            post["CommentTitle"] = review.commentTitle!
        }
        if let com = comment.text{
            review.comment = com
            print(review.comment)
            post["Comment"] = review.comment
        }
        
        if (review.courseName == "" || review.courseName == "" || review.comment == "" || review.difficultValue == ""||commentTextchanged != true || commentTitleChanged != true)
        {
            flag = 0
        }
        
        if (flag == 1){

            
            let databaseRef = FIRDatabase.database().reference()
            CurrentProfessor.departmentName = CurrentProfessor.departmentName.stringByReplacingOccurrencesOfString(" ", withString: "")
            
            // Compute and update the average rating.
            
            databaseRef.child("Professor").child("Department").child(CurrentProfessor.departmentName).child(CurrentProfessor.imageName).observeSingleEventOfType(.Value, withBlock: { snapProfessor in
            
                if !snapProfessor.exists() { return }
                
                let averageRating = snapProfessor.value!["AverageRating"] as! Float
                let averageDifficulty = snapProfessor.value!["AverageDifficulty"] as! Float
                
                databaseRef.child("Professor").child("Department").child(CurrentProfessor.departmentName).child(CurrentProfessor.imageName).child("Ratings").observeSingleEventOfType(.Value, withBlock: {snapshot in
                    
                    let numberOfReviews = (Float)(snapshot.childrenCount)
                    let newRating = (Float)(self.review.ratingValue!)
                    let newDifficulty = (Float)(self.review.difficultValue!)
                    
                    let newRatingAvg = (((averageRating * numberOfReviews) + newRating!) / (numberOfReviews + 1))
                    let newDifficultAvg = (((averageDifficulty * numberOfReviews) + newDifficulty!) / (numberOfReviews + 1))
                    
                    databaseRef.child("Professor").child("Department").child(CurrentProfessor.departmentName).child(CurrentProfessor.imageName).child("AverageDifficulty").setValue(newDifficultAvg)
                    
                    databaseRef.child("Professor").child("Department").child(CurrentProfessor.departmentName).child(CurrentProfessor.imageName).child("AverageRating").setValue(newRatingAvg)
                    
                    databaseRef.child("Professor").child("Department").child(CurrentProfessor.departmentName).child(CurrentProfessor.imageName).child("Ratings").childByAutoId().setValue(post)
                
                })
                
            
            })
            
            
            print("\(CurrentProfessor.departmentName) && \(CurrentProfessor.imageName)")

            
            let alert = UIAlertController(title: "Submission Successful", message: "You have successfully posted review!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: returnToPreviousView))
            self.presentViewController(alert, animated: true, completion: nil)
            
     
            
        }
        else{
            let alert = UIAlertController(title: "Submission Failed", message: "Some fields are empty. To successfully submit your review complete all fields.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
    }
    
    func returnToPreviousView(alert: UIAlertAction!)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // Hides keyboard when user taps the background
    @IBAction func userTappedBackground( gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
}

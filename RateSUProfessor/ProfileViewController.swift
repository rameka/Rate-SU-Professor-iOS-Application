//
//  ProfileViewController.swift
//  
//
//  Created by Ramakrishna Sayee on 4/19/17.
//  Copyright © 2017 Syracuse University. All rights reserved.
//

import Foundation
import UIKit
class ProfileViewController: UIViewController, UICollisionBehaviorDelegate {
    
    @IBOutlet weak var displayPicture: UIImageView!
    
    // Headers for the tabs in Professor Profile View
    let tabs = ["Profile","Rating and Reviews"]
    var views = [UIView]()
    @IBOutlet weak var rateButton: UIButton!
    
    // This index value is fetched fom another view controller
    var indexValue:Int!
    
    
    @IBOutlet weak var overallRating: UILabel!
    @IBOutlet weak var overallDifficulty: UILabel!
    @IBOutlet weak var professorDesignation: UILabel!
    @IBOutlet weak var professorName: UILabel!
    
    // Variables declared for enabling slide effect
    var animator:UIDynamicAnimator!
    var gravity:UIGravityBehavior!
    var snap:UISnapBehavior!
    var previousTouchPoint:CGPoint!
    var viewDragging = false
    var viewPinned = false
    
    // To proceed to rateing page on user action
    @IBAction func rateClicked(sender: UIButton) {
        
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("RateView") as! RateViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customizing the rate button in the view
        rateButton.backgroundColor=UIColor.clearColor()
        rateButton.layer.borderWidth = 2
        rateButton.layer.borderColor = UIColor.init(red: 255/255.0, green: 127/255.0, blue: 0/255.0, alpha: 1).CGColor
        rateButton.layer.cornerRadius = 20
        rateButton.clipsToBounds = true
        
        // Fetching the Professor Image
        displayPicture.image = UIImage(named: CurrentProfessor.imageName)
        
        animator = UIDynamicAnimator(referenceView: self.view)
        gravity = UIGravityBehavior()
        
        animator.addBehavior(gravity)
        gravity.magnitude = 4
        
        // offset value used for positioning the profile view and rating view in the in the same page for slide effect
        var offset:CGFloat = 220
        
        // Adding the two sub views on the Profile View
        for i in 0 ... tabs.count - 1 {
            if (i==0){
                let view = addViewController1(atOffset: offset, dataForVC: tabs[i])
                views.append(view!)
               
            }
            else{
                
                let view = addViewController2(atOffset: offset, dataForVC: tabs[i])
                views.append(view!)
            }
             offset -= 75
        }
        
        // Customizing the professor image on view
        displayPicture.layer.masksToBounds = false
        displayPicture.layer.cornerRadius = displayPicture.frame.size.height/2
        displayPicture.clipsToBounds = true
    }
  
    override func viewWillAppear(animated: Bool) {
        Model.updateDB()
        professorName.text = Model.cellArray[indexValue].profName
        professorDesignation.text = Model.cellArray[indexValue].profDesignation
        overallRating.text = String(format: "%0.1f",Model.cellArray[indexValue].avgRating)
        overallDifficulty.text = String(format: "%0.1f", Model.cellArray[indexValue].avgDifficulty)
        
        // rate button is displayed to the user only if the user is a syracuse university student
        if   DatabaseController.userProfile.emailId.rangeOfString("syr.edu") == nil {
            rateButton.hidden = true
        }

    }
    
    // Adding the Profile tab on the view with animation properties
    func addViewController1 (atOffset offset:CGFloat, dataForVC data:AnyObject?) -> UIView? {
        
        
        let frameForView = self.view.bounds.offsetBy(dx: 0, dy: self.view.bounds.size.height - offset)
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let stackElementVC = sb.instantiateViewControllerWithIdentifier("StackElement1") as! StackElementProfileController
       
        
        if let view = stackElementVC.view {
            view.frame = frameForView
            view.layer.cornerRadius = 5
            view.layer.shadowOffset = CGSize(width: 2, height: 2)
            view.layer.shadowColor = UIColor.blueColor().CGColor//UIColor.black.cgColor
            view.layer.shadowRadius = 3
            view.layer.shadowOpacity = 0.5
            
            
            if let headerStr = data as? String {
                stackElementVC.headerString = headerStr
                
            }
            
            stackElementVC.Index = indexValue
            
            self.addChildViewController(stackElementVC)
            self.view.addSubview(view)
            stackElementVC.didMoveToParentViewController(self)
            
            
            
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ProfileViewController.handlePan(_:)))
            view.addGestureRecognizer(panGestureRecognizer)
            
            
            let collision = UICollisionBehavior(items: [view])
            collision.collisionDelegate = self
            
            animator.addBehavior(collision)
            
            let boundary = view.frame.origin.y + view.frame.size.height
            
            // lower boundary
            var boundaryStart = CGPoint(x: 0, y: boundary)
            var boundaryEnd = CGPoint(x: self.view.bounds.size.width, y: boundary)
            collision.addBoundaryWithIdentifier(1, fromPoint: boundaryStart, toPoint: boundaryEnd)
            
            
            // upper boundary
            boundaryStart = CGPoint(x: 0, y: 0)
            boundaryEnd = CGPoint(x: self.view.bounds.size.width, y: 0)
            collision.addBoundaryWithIdentifier(2, fromPoint: boundaryStart, toPoint: boundaryEnd)
            gravity.addItem(view)
            
            
            let itemBehavior = UIDynamicItemBehavior(items: [view])
            animator.addBehavior(itemBehavior)
            
            return view
            
            
        }
        
        return nil
     
    }
    
    // Adding the Ratings and Reviews tab on view with animation properties
    func addViewController2 (atOffset offset:CGFloat, dataForVC data:AnyObject?) -> UIView? {
        
        
        let frameForView = self.view.bounds.offsetBy(dx: 0, dy: self.view.bounds.size.height - offset)
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let stackElementVC = sb.instantiateViewControllerWithIdentifier("StackElement2") as! RatingViewController
        
        
        if let view = stackElementVC.view {
            view.frame = frameForView
            view.layer.cornerRadius = 5
            view.layer.shadowOffset = CGSize(width: 2, height: 2)
            view.layer.shadowColor = UIColor.blueColor().CGColor//UIColor.black.cgColor
            view.layer.shadowRadius = 3
            view.layer.shadowOpacity = 0.5
            
            
            if let headerStr = data as? String {
                stackElementVC.headerString = headerStr
            }
            
            stackElementVC.Index = indexValue
            
            self.addChildViewController(stackElementVC)
            self.view.addSubview(view)
            stackElementVC.didMoveToParentViewController(self)
            
            
            
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ProfileViewController.handlePan(_:)))
            view.addGestureRecognizer(panGestureRecognizer)
            
            
            let collision = UICollisionBehavior(items: [view])
            collision.collisionDelegate = self
            
            animator.addBehavior(collision)
            
            let boundary = view.frame.origin.y + view.frame.size.height
            
            // lower boundary
            var boundaryStart = CGPoint(x: 0, y: boundary)
            var boundaryEnd = CGPoint(x: self.view.bounds.size.width, y: boundary)
            collision.addBoundaryWithIdentifier(1, fromPoint: boundaryStart, toPoint: boundaryEnd)
            
            
            // upper boundary
            boundaryStart = CGPoint(x: 0, y: 0)
            boundaryEnd = CGPoint(x: self.view.bounds.size.width, y: 0)
            collision.addBoundaryWithIdentifier(2, fromPoint: boundaryStart, toPoint: boundaryEnd)
            gravity.addItem(view)
            
            
            let itemBehavior = UIDynamicItemBehavior(items: [view])
            animator.addBehavior(itemBehavior)
            
            return view
            
            
        }
        
        return nil
        
    }
    
    // Function which enables the holding and dragging animation for the sub views, i.e. profile tab and review tab
    func handlePan (gestureRecognizer:UIPanGestureRecognizer) {
        
        let touchPoint = gestureRecognizer.locationInView(self.view)
        let draggedView = gestureRecognizer.view!
        
        
        if gestureRecognizer.state == .Began {
            let dragStartPoint = gestureRecognizer.locationInView(draggedView)
            
            if dragStartPoint.y < 200 {
                viewDragging = true
                previousTouchPoint = touchPoint
            }
            
            
        } else if gestureRecognizer.state == .Changed && viewDragging {
            let yOffset = previousTouchPoint.y - touchPoint.y
            
            draggedView.center = CGPoint(x: draggedView.center.x, y: draggedView.center.y - yOffset)
            previousTouchPoint = touchPoint
        }else if gestureRecognizer.state == .Ended && viewDragging {
            
            pin(draggedView)
            addVelocity(toView: draggedView, fromGestureRecognizer: gestureRecognizer)
            animator.updateItemUsingCurrentState(draggedView)
            viewDragging = false
            
        }

    }
    
    // function to pin the view on top of another view controller
    func pin (view:UIView) {
        
        let viewHasReachedPinLocation = view.frame.origin.y < 100
        
        if viewHasReachedPinLocation {
            if !viewPinned {
                var snapPosition = self.view.center
                snapPosition.y += 30
                
                snap = UISnapBehavior(item: view, snapToPoint: snapPosition)
                animator.addBehavior(snap)
                
                setVisibility(view, alpha: 0)
                
                viewPinned = true
                
                
            }
        }else{
            if viewPinned {
                animator.removeBehavior(snap)
                setVisibility(view, alpha: 1)
                viewPinned = false
            }
        }
        
        
    }
    
    // Making the selected view visible
    func setVisibility (view:UIView, alpha:CGFloat) {
        for aView in views {
            if aView != view {
                aView.alpha = alpha
            }
        }
    }
    
    
    // Adding velocity with which the view gets dropped
    func addVelocity (toView view:UIView, fromGestureRecognizer panGesture:UIPanGestureRecognizer) {
        var velocity = panGesture.velocityInView(self.view)
        
        velocity.x = 0
        
        if let behavior = itemBehavior(forView: view) {
            behavior.addLinearVelocity(velocity, forItem: view)
        }
        
        
    }
    
    // This function is used to record the item behaviour
    func itemBehavior (forView view:UIView) -> UIDynamicItemBehavior? {
        for behavior in animator.behaviors {
            if let itemBehavior = behavior as? UIDynamicItemBehavior {
                if let possibleView = itemBehavior.items.first as? UIView where possibleView == view {
                    return itemBehavior
                }
            }
        }
        
        return nil
    }

    // Collision between Rating tab and profile tab is managed here
    func collisionBehavior(_behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        
        if NSNumber(integerLiteral: 2).isEqual(identifier) {
            let view = item as! UIView
            pin(view)
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}

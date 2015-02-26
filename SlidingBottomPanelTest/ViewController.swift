//
//  ViewController.swift
//  SlidingBottomPanelTest
//
//  Created by Hector Monserrate  on 2/25/15.
//  Copyright (c) 2015 Hector Monserrate . All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var sliderBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var slidingPanelView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let slidePanGesture = UIPanGestureRecognizer(target: self, action: "didPanSlide:")
        slidingPanelView.addGestureRecognizer(slidePanGesture)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableViewTopConstraint.constant += slidingPanelView.bounds.height + 10
        
        var tablePanGesture = UIPanGestureRecognizer(target: self, action: "didPanTable:")
        tableView.addGestureRecognizer(tablePanGesture)
    }

    
    func didPanSlide(gesture: UIPanGestureRecognizer) {
        var touch = gesture.translationInView(gesture.view!)
        var location = gesture.locationInView(view)
        
        switch gesture.state {
        case .Began:
            println("slide up started")
        case .Changed:
            sliderBottomConstraint.constant -= touch.y
            
            slidingPanelView.layoutIfNeeded()
            
        case .Ended:
            println("slide up ended")
            let newConstraintConstant = slidingPanelView.center.y > screenHeight / 2 ? 0 : screenHeight - slidingPanelView.bounds.height
            
//            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
//                self.sliderBottomConstraint.constant = newConstraintConstant
//                self.slidingPanelView.layoutIfNeeded()
//                self.tableView.layoutIfNeeded()
//            }, completion: nil)
            
        default:
            println("state I dont care about")
        }
        
        gesture.setTranslation(CGPointZero, inView: gesture.view)
    }
    
    @IBAction func didPanTable(gesture: UIPanGestureRecognizer) {
        var touch = gesture.translationInView(gesture.view!)
        var location = gesture.locationInView(view)
        
        switch gesture.state {
        case .Began:
            println("slide up started")
        case .Changed:
            if didOverflowOnTop() {
                let offsetY = tableView.contentOffset.y - touch.y;
                
                if offsetY > 0 {
                    if offsetY < tableView.contentSize.height - screenHeight + tableViewTopConstraint.constant {
                        tableView.setContentOffset(CGPointMake(0, offsetY), animated: false)
                    }
                } else {
                    sliderBottomConstraint.constant -= touch.y
                }
            } else {
                sliderBottomConstraint.constant -= touch.y
            }
            
            slidingPanelView.layoutIfNeeded()
            
        case .Ended:
            let newConstraintConstant = slidingPanelView.center.y > screenHeight / 2 ? 0 : screenHeight - slidingPanelView.bounds.height
            
        default:
            println("state I dont care about")
        }
        
        gesture.setTranslation(CGPointZero, inView: gesture.view)
    }
    
    func didOverflowOnTop() -> Bool {
        return slidingPanelView.center.y - (slidingPanelView.bounds.height / 2) <= 0
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("SimpleTableItem") as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "SimpleTableItem")
        }
        
        cell?.textLabel?.text = "this is row number \(indexPath.row)"
        
        return cell!
    }
}


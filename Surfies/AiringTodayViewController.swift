//
//  AiringTodayViewController.swift
//  Surfies
//
//  Created by Barbara Brina on 8/24/15.
//  Copyright (c) 2015 Barbara Brina. All rights reserved.
//

import UIKit
import JDFTooltips

class AiringTodayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate {

    // MARK: Variables
    
    var airingTodayShows = [TVShow]()
    
    var tooltipManager: JDFSequentialTooltipManager!
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: iOS
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        
        TVShow.getAiringToday { (response) -> () in
            switch response {
            case .Failure(let error):
                print(error, terminator: "")
                
            case .Success(let shows):
                self.airingTodayShows = shows
                self.tableView.reloadData()
                
            }
        }
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: "goBack:")
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(rightSwipe)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        let backButton = UIBarButtonItem(image: UIImage(named: "Back"), style: UIBarButtonItemStyle.Plain, target: self, action: "didSelectBack")
        self.navigationItem.leftBarButtonItem = backButton
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var token: dispatch_once_t = 0
        dispatch_once(&token) { () -> Void in
            self.tableView.contentInset = UIEdgeInsetsZero
        }
    }
    
    // MARK: Recommendations
    
    func goBack(sender: UISwipeGestureRecognizer) {
        if sender.direction == .Right {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    // MARK: Navigation Bar
    
    func didSelectBack() {
        
        self.navigationController?.popViewControllerAnimated(true)
    }

    // MARK: Table View

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return airingTodayShows.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AiringTodayCell", forIndexPath: indexPath) as! AiringTodayTableViewCell
        cell.showName.text = airingTodayShows[indexPath.row].originalName
        cell.backdropImage.sd_setImageWithURL(airingTodayShows[indexPath.row].backdropURL, placeholderImage: UIImage(named: "nopreview"))
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("TodayEpisode") as! TodayEpisodeViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let moreInfoAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "More") { (action: UITableViewRowAction, indexPath) -> Void in
            
            let showDes = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ShowDescription") as! DescriptionViewController
            
            showDes.currentShow = self.airingTodayShows[indexPath.row]
            showDes.modalPresentationStyle = UIModalPresentationStyle.Custom
            showDes.transitioningDelegate = self
            self.presentViewController(showDes, animated: true, completion: nil)
            
        }
        
        moreInfoAction.backgroundColor = UIColor.blackColor()
        
        return [moreInfoAction]
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        var token: dispatch_once_t = 0
        
        if userDefaults.boolForKey(hasShownAiringTodayInstructionsKey) == false {
            dispatch_once(&token, { () -> Void in
                if indexPath.row == 0 {
                    self.tooltipManager = JDFSequentialTooltipManager(hostView: self.view)
                    self.tooltipManager.addTooltipWithTargetView(cell.contentView.subviews.first as UIView!, hostView: self.view, tooltipText: "Swipe left for more information on the show.", arrowDirection: JDFTooltipViewArrowDirection.Up, width: 200.0)
                    self.tooltipManager.addTooltipWithTargetView(cell.contentView.subviews.first as UIView!, hostView: self.view, tooltipText: "Tap for information on today's episode.", arrowDirection: JDFTooltipViewArrowDirection.Up, width: 200.0)
                    self.styleTooltip()
                    self.tooltipManager.showAllTooltips()
                    userDefaults.setBool(true, forKey: hasShownAiringTodayInstructionsKey)
                    
                }
                
            })
            
            }
            
            var rotation: CATransform3D
            let value = CGFloat((90.0 * M_PI)/180.0)
            rotation = CATransform3DMakeRotation(value, 0.0, 0.7, 0.4)
            rotation.m34 = 1.0 / -600
            
            cell.layer.shadowColor = UIColor.blackColor().CGColor
            cell.layer.shadowOffset = CGSizeMake(10, 10)
            cell.alpha = 0
            
            cell.layer.transform = rotation
            cell.layer.anchorPoint = CGPointMake(0, 0.5)
        
            if(cell.layer.position.x != 0){
            cell.layer.position = CGPointMake(0, cell.layer.position.y);
            }
            
            UIView.beginAnimations("rotation", context: nil)
            UIView.setAnimationDuration(0.8)
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1
            cell.layer.shadowOffset = CGSizeMake(0, 0)
            UIView.commitAnimations()
        
    }
    
    // MARK: Description Modal
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentingAnimator()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissingAnimator()
    }
    
    // MARK: Tooltip
    
    func styleTooltip() {
        tooltipManager.setFontForAllTooltips(UIFont(name: "OpenSans", size: 15))
        tooltipManager.setBackgroundColourForAllTooltips(UIColor.whiteColor().colorWithAlphaComponent(0.9))
        tooltipManager.setTextColourForAllTooltips(UIColor.blackColor())
        
    }
    

}

//
//  SelectedEpisodeViewController.swift
//  Surfies
//
//  Created by Barbara Brina on 8/6/15.
//  Copyright (c) 2015 Barbara Brina. All rights reserved.
//

import UIKit
import VBFPopFlatButton
import QuartzCore
import DOFavoriteButton
import SDWebImage
import JDFTooltips

class SelectedEpisodeViewController: UIViewController {
   
    // MARK: Variables
    
    var currentShowId: Int!
    
    var currentSeason: Int!
    
    var currentEpisode: Int!
    
    var selectedEpisode = TVShow()
    
    var isASavedShow: Bool!
    
    var tooltipManager: JDFSequentialTooltipManager!
    
    // MARK: Outlets
    
    @IBOutlet weak var backdropImage: UIImageView!
    
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var gradientView2: UIView!
    
    @IBOutlet weak var watchedEpisode: DOFavoriteButton!
    
    @IBOutlet weak var episodeDescription: UITextView!
    
    @IBOutlet weak var menuButton: VBFPopFlatButton!
   
    // MARK: Actions
    
    @IBAction func openMenu(sender: AnyObject) {
        
        let menu = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MenuView") as!
        MenuViewController
        
        let mainNavContr = self.navigationController as! MainNavigationController
        
        menu.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        menu.delegate = mainNavContr
        
        presentViewController(menu, animated: false, completion: nil)
        
    }
    
    // MARK: iOS
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        createTooltip()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TVShow.getEpisodeInfo(currentShowId, seasonNumber: currentSeason, episodeNumber: currentEpisode) { (response) -> () in
            switch response {
            case .Failure(let error):
                print(error, terminator: "")
            case .Success(let episodeInfo):
                self.selectedEpisode = episodeInfo
                self.updateScreen()
                
            }
        }

        watchedEpisode.addTarget(self, action: #selector(SelectedEpisodeViewController.tapped(_:)), forControlEvents: .TouchUpInside)
        
        addGradient()
        addGradienToTextView()
        
        episodeDescription.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 65, right: 0)
        
        styleMenu()
        
        UserWatchedEpisodes.wasWatched(currentShowId, season: currentSeason, episode: currentEpisode) { (response) -> Void in
            switch response {
            case .Success(let isSaved):
                self.isASavedShow = isSaved
                
                if self.isASavedShow == true {
                    self.watchedEpisode.selected = true
                } else {
                    self.watchedEpisode.selected = false
                }
                
            case .Failure(let error):
                print(error, terminator: "")
                
            }
        }
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(SelectedEpisodeViewController.goBack(_:)))
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(rightSwipe)
    }
    
       

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        let backButton = UIBarButtonItem(image: UIImage(named: "Back"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SelectedEpisodeViewController.didSelectBack))
        self.navigationItem.leftBarButtonItem = backButton
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
                
    }
    
    // MARK: Back
    
    func goBack(sender: UISwipeGestureRecognizer) {
        if sender.direction == .Right {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    // MARK: Navigation Bar
    
    func didSelectBack() {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: Menu
 
    func styleMenu() {
        
        menuButton.currentButtonType = FlatButtonType.buttonMenuType
        menuButton.currentButtonStyle = FlatButtonStyle.buttonPlainStyle
        menuButton.lineThickness = 2
        menuButton.tintColor = UIColor.whiteColor()
    }
    
    // MARK: View

    func addGradient() {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = gradientView.bounds
        
        let color1 = UIColor.clearColor().CGColor
        let color2 = UIColor.blackColor().CGColor
        let arrayColors = [color1, color2]
        
        gradient.colors = arrayColors
        
        gradientView.layer.addSublayer(gradient)
    }
    
    func addGradienToTextView() {
     
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = gradientView2.bounds
        
        let color1 = UIColor.clearColor().CGColor
        let color2 = UIColor.blackColor().CGColor
        let arrayColors = [color1, color2]
        
        gradient.colors = arrayColors
        
        gradientView2.layer.addSublayer(gradient)
    }
    
    func updateScreen() {
        episodeDescription.text = selectedEpisode.episodeDescription
        self.navigationItem.title = selectedEpisode.episodeName
        backdropImage.sd_setImageWithURL(selectedEpisode.episodePicutreURL)
        
    }
    
    // MARK: DOFavoriteButton
    
    func tapped(sender: DOFavoriteButton) {
        if sender.selected {
            sender.deselect()
        } else {
            UserWatchedEpisodes.userWatchedEpisode(currentShowId, season: currentSeason, episode: currentEpisode, response: { (response) -> Void in
                switch response {
                case .Failure(let error):
                    print(error, terminator: "")
                    
                case .Success(_):
                    print("watchedEpisode Success", terminator: "")
                }
            })
            
            sender.select()
        }
    }
    
    // MARK: Tooltip
    
    func createTooltip() {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if userDefaults.boolForKey(hasShownSelectedEpisodeInstructionsKey) == false {
            
            tooltipManager = JDFSequentialTooltipManager(hostView: self.view)
            tooltipManager.addTooltipWithTargetView(watchedEpisode, hostView: self.view, tooltipText: "Tap to mark an episode as watched.", arrowDirection: JDFTooltipViewArrowDirection.Down, width: 200.0)
            
            
            tooltipManager.setFontForAllTooltips(UIFont(name: "OpenSans", size: 15))
            tooltipManager.setBackgroundColourForAllTooltips(UIColor.whiteColor().colorWithAlphaComponent(0.9))
            tooltipManager.setTextColourForAllTooltips(UIColor.blackColor())
            
            tooltipManager.showAllTooltips()
            userDefaults.setBool(true, forKey: hasShownSelectedEpisodeInstructionsKey)
            
        }
        
    }

}

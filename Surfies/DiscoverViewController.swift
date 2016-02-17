//
//  DiscoverViewController.swift
//  Surfies
//
//  Created by Barbara Brina on 6/22/15.
//  Copyright (c) 2015 Barbara Brina. All rights reserved.
//

import UIKit
import SDWebImage
import VBFPopFlatButton
import Parse
import Koloda

class DiscoverViewController: UIViewController, KolodaViewDataSource, KolodaViewDelegate {
    
    // MARK: Variables
    
    var response = ""
    
    var tvShows = [TVShow]()
    
    var numberOfCards: UInt = 20
    
    // MARK: Outlets
    
    @IBOutlet weak var menuButton: VBFPopFlatButton!
    
    @IBOutlet weak var showPoster: KolodaView!
    
    // MARK: Actions
    
    @IBAction func openMenu(sender: AnyObject) {
        let menu = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MenuView") as!
        MenuViewController
        
        let mainNavContr = self.navigationController as! MainNavigationController
        
        menu.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        menu.delegate = mainNavContr
        
        presentViewController(menu, animated: false, completion: nil)
    }
    
    
    @IBAction func notLiked(sender: AnyObject) {
        showPoster.swipe(SwipeResultDirection.Left)
    }
    
    
    @IBAction func liked(sender: AnyObject) {
        
        let show = self.tvShows[showPoster.currentCardNumber]
        
        UserLikedShows.userLikedShow(show, response: { (response) -> Void in
            switch response {
            case .Failure(let error):
                print(error)
            case .Success(_):
                print("like success")
            }
        })
        
        showPoster.swipe(SwipeResultDirection.Right)
    }
    
    
    // MARK: iOS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showPoster.layer.cornerRadius = 10
        
        showPoster.dataSource = self
        showPoster.delegate = self
        
        TVShow.getPopular { (response) -> () in
            switch response {
                
            case .Success(let shows) :
                self.tvShows = shows
                self.showPoster.reloadData()
                
            case .Failure(let error) :
                print(error, terminator: "")
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        styleMenu()
    }
    
    // MARK: Go to Recommendations
    
    func changeController() {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.setBool(true, forKey: didFinishRecommendationsKey)
        
        let mainNavContr = self.navigationController as! MainNavigationController
        let recommendationsViewController = self.storyboard!.instantiateViewControllerWithIdentifier("Recommendations") 
        mainNavContr.setViewControllers([recommendationsViewController], animated: true)
        
    }
    
    // MARK: Menu
    
    func styleMenu() {
        
        menuButton.currentButtonType = FlatButtonType.buttonMenuType
        menuButton.currentButtonStyle = FlatButtonStyle.buttonPlainStyle
        menuButton.lineThickness = 2
        menuButton.tintColor = UIColor.whiteColor()
    }
    
    // MARK: Koloda
    func kolodaNumberOfCards(koloda: KolodaView) -> UInt {
        return numberOfCards
    }
    
    func kolodaViewForCardAtIndex(koloda: KolodaView, index: UInt) -> UIView {
        
        let bg = UIImageView()
        
        bg.frame = showPoster.bounds
        
        if tvShows.count > 0 {
            bg.sd_setImageWithURL(tvShows[Int(index)].posterURL, placeholderImage: UIImage(named: "nopreview"))
            
            view.insertSubview(bg, aboveSubview: showPoster)
            
            return bg
        } else {
            return UIImageView(image: UIImage(named: "nopreview"))
        }
        
    }
    
    func kolodaViewForCardOverlayAtIndex(koloda: KolodaView, index: UInt) -> OverlayView? {
        return nil
    }
    
    func kolodaDidSwipedCardAtIndex(koloda: KolodaView, index: UInt, direction: SwipeResultDirection) {

        if direction == SwipeResultDirection.Right {
            
            let show = self.tvShows[Int(index)]
            
            UserLikedShows.userLikedShow(show, response: { (response) -> Void in
                switch response {
                case .Failure(let error):
                    print(error)
                case .Success(_):
                    print("like success")
                }
            })
        }
        
    }
    
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        changeController()
    }
    
    func kolodaShouldApplyAppearAnimation(koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldMoveBackgroundCard(koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldTransparentizeNextCard(koloda: KolodaView) -> Bool {
        return true
    }
 
}

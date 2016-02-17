//
//  SeasonsViewController.swift
//  Surfies
//
//  Created by Barbara Brina on 8/4/15.
//  Copyright (c) 2015 Barbara Brina. All rights reserved.
//

import UIKit
import VBFPopFlatButton

class SeasonsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    // MARK: Variables
    
    var currentShowId: Int!
    
    var currentShow = TVShow()
    
    var seasonsInShow: Int!
    
    // MARK: Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TVShow.getShowInfo(currentShowId, response: { (response) -> () in
            switch response {
            case .Failure(let error):
                print(error, terminator: "")
                
            case .Success(let show):
                self.currentShow = show
                self.collectionView.reloadData()
            }
        })
        
        let collectionViewLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: UIScreen.mainScreen().bounds.size.width / 20 , bottom: 0, right: UIScreen.mainScreen().bounds.size.width / 20)
        let width = (UIScreen.mainScreen().bounds.width - collectionViewLayout.sectionInset.left - collectionViewLayout.sectionInset.right - collectionViewLayout.sectionInset.left) / 2
        
        collectionViewLayout.itemSize = CGSize(width: width, height: width)
        
        collectionViewLayout.minimumLineSpacing = collectionViewLayout.sectionInset.left
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: "goBack:")
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(rightSwipe)

    
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        let backButton = UIBarButtonItem(image: UIImage(named: "Back"), style: UIBarButtonItemStyle.Plain, target: self, action: "didSelectBack")
        self.navigationItem.leftBarButtonItem = backButton
        
        styleMenu()
        
    }
    
    // MARK: My Series
    
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
    
    // MARK: Collection View
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return currentShow.showSeasons
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("seasonsCell", forIndexPath: indexPath) as! SeasonsCollectionViewCell
        cell.seasonNumber.text = "Season \(indexPath.row + 1)"
        cell.layer.cornerRadius = 10
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let showId = self.currentShowId
        let selectedSeason = (indexPath.row + 1)
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("Episodes") as! EpisodesViewController
        controller.currentSeason = selectedSeason
        controller.currentShowId = showId
        self.navigationController?.pushViewController(controller, animated: true)
    }

}

//
//  EpisodesViewController.swift
//  Surfies
//
//  Created by Barbara Brina on 8/6/15.
//  Copyright (c) 2015 Barbara Brina. All rights reserved.
//

import UIKit
import VBFPopFlatButton

class EpisodesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{

    // MARK: Variables
    
    var currentSeason: Int!
    
    var currentShowId: Int!
    
    var episodeList = [TVShow]()
    
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
        
        styleMenu()

        TVShow.getSeasonEpisodes(currentShowId, seasonNumber: currentSeason) { (response) -> () in
            switch response {
            case .Failure(let error):
                print(error, terminator: "")
                
            case .Success(let seasonEpisodes):
                self.episodeList = seasonEpisodes
                self.collectionView.reloadData()
                
            }
        }
        
        let collectionViewLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: UIScreen.mainScreen().bounds.size.width / 25 , bottom: 0, right: UIScreen.mainScreen().bounds.size.width / 25)
        let width = (UIScreen.mainScreen().bounds.width - collectionViewLayout.sectionInset.right - (collectionViewLayout.sectionInset.left * 3)) / 3
        
        collectionViewLayout.itemSize = CGSize(width: width, height: width)
        
        collectionViewLayout.minimumLineSpacing = collectionViewLayout.sectionInset.left
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(EpisodesViewController.goBack(_:)))
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(rightSwipe)

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        let backButton = UIBarButtonItem(image: UIImage(named: "Back"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EpisodesViewController.didSelectBack))
        self.navigationItem.leftBarButtonItem = backButton

        
    }
    
    // MARK: Seasons
    
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
        return episodeList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("episodesCell", forIndexPath: indexPath) as! EpisodesCollectionViewCell
        cell.episodeNumber.text = "\(indexPath.row + 1)"
        cell.layer.cornerRadius = 10
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let showId = self.currentShowId
        let season = self.currentSeason
        let selectedEpisode = (indexPath.row + 1)
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("SelectedEpisode") as! SelectedEpisodeViewController
        controller.currentSeason = season
        controller.currentShowId = showId
        controller.currentEpisode = selectedEpisode
        self.navigationController?.pushViewController(controller, animated: true)
    }

    

}

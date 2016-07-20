//
//  MySeriesViewController.swift
//  
//
//  Created by Barbara Brina on 7/10/15.
//
//

import UIKit
import VBFPopFlatButton
import SDWebImage
import Parse
import JDFTooltips


class MySeriesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate, UIViewControllerTransitioningDelegate, DeleteAlertControllerDelegate {
    
    // MARK: Variables
    
    var series = [TVShow]()
    
    var showToDelete = TVShow()
    
    var indexForShow: Int!
    
    var tooltipManager: JDFSequentialTooltipManager!
    
    var token: dispatch_once_t = 0
    
    // MARK: Outlets
    
    @IBOutlet weak var mySeriesCollectionView: UICollectionView!
    
    @IBOutlet weak var menuB: VBFPopFlatButton!

    // MARK: Actions
    
    
    @IBAction func menuButton(sender: AnyObject) {
        
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

        
        UserSavedShows.getSavedShows { (response) -> Void in
            
            switch response {
            case .Success(let savedShows):
                self.series = savedShows
                self.mySeriesCollectionView.reloadData()
                
            case .Failure(let error):
                print(error, terminator: "")
            }
            
        }
        
        let collectionViewLayout = mySeriesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: UIScreen.mainScreen().bounds.size.width / 20 , bottom: 0, right: UIScreen.mainScreen().bounds.size.width / 20)
        let width = (UIScreen.mainScreen().bounds.width - collectionViewLayout.sectionInset.left - collectionViewLayout.sectionInset.right - collectionViewLayout.sectionInset.left) / 2
        
        collectionViewLayout.itemSize = CGSize(width: width, height: width * 250 / 160)
        
        collectionViewLayout.minimumLineSpacing = collectionViewLayout.sectionInset.left
        
        styleMenu()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        mySeriesCollectionView.reloadData()
        
    }
    

    
    // MARK: Collection View
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return series.count
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if userDefaults.boolForKey(hasShownMySeriesInstructionsKey) == false {
            dispatch_once(&token, { () -> Void in
                if indexPath.row == 0 {
                    self.tooltipManager = JDFSequentialTooltipManager(hostView: self.view)
                    self.tooltipManager.addTooltipWithTargetView(cell.contentView.subviews.first as UIView!, hostView: self.view, tooltipText: "Long press to delete a saved show.", arrowDirection: JDFTooltipViewArrowDirection.Up, width: 200.0)
                    self.styleTooltip()
                    self.tooltipManager.showAllTooltips()
                    userDefaults.setBool(true, forKey: hasShownMySeriesInstructionsKey)
                    
                }
                
            })
            
        }
        
    }

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("seriesCell", forIndexPath: indexPath) as! SeriesPosterCollectionViewCell
        let showPosterUrl = series[indexPath.row].posterURL
        cell.seriePoster.sd_setImageWithURL(showPosterUrl, placeholderImage: UIImage(named: "nopreview"))
        let longPress: UIGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(MySeriesViewController.action(_:)))
        cell.addGestureRecognizer(longPress)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let selectedShow = series[indexPath.row].serieId
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("Seasons") as! SeasonsViewController
        controller.currentShowId = selectedShow
        self.navigationController?.pushViewController(controller, animated: true)
        
        
        
    }
    
    func action(gestureRecognizer: UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state == .Began {
            
            let cell = gestureRecognizer.view as! UICollectionViewCell
            indexForShow = self.mySeriesCollectionView.indexPathForCell(cell)!.item
            showToDelete = series[indexForShow]
            
            deletePopup()
            
        }
    }
    
    // MARK: Alert Controller
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentingAnimator()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissingAnimator()
    }
    
    func deletePopup() {
        
        let deleteAlert = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DeleteAlert") as! DeleteAlertViewController
        
        deleteAlert.currentDelegate = self
        deleteAlert.modalPresentationStyle = UIModalPresentationStyle.Custom
        deleteAlert.transitioningDelegate = self
        presentViewController(deleteAlert, animated: true, completion: nil)

        
    }
    
    func userDidPressDelete() {
        let parseShow = UserSavedShows(withoutDataWithObjectId: showToDelete.parseObjectId)
            parseShow.deleteInBackgroundWithBlock { (success, error) -> Void in

                if let error = error {
                    print(error, terminator: "")
                } else {
                    self.series.removeAtIndex(self.indexForShow)
                    self.mySeriesCollectionView.reloadData()
                    print("show deleted", terminator: "")
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                
            }

        
    }
    
    // MARK: Menu
    
    func styleMenu() {
        
        menuB.currentButtonType = FlatButtonType.buttonMenuType
        menuB.currentButtonStyle = FlatButtonStyle.buttonPlainStyle
        menuB.lineThickness = 2
        menuB.tintColor = UIColor.whiteColor()
    }
    
    // MARK: Tooltip
    
    func styleTooltip() {
        tooltipManager.setFontForAllTooltips(UIFont(name: "OpenSans", size: 15))
        tooltipManager.setBackgroundColourForAllTooltips(UIColor.whiteColor().colorWithAlphaComponent(0.9))
        tooltipManager.setTextColourForAllTooltips(UIColor.blackColor())
        
    }
    

}

//
//  RecommendationViewController.swift
//  
//
//  Created by Barbara Brina on 6/30/15.
//
//

import UIKit
import VBFPopFlatButton
import AKPickerView_Swift
import QuartzCore
import SDWebImage
import JDFTooltips

class RecommendationViewController: UIViewController, AKPickerViewDataSource, AKPickerViewDelegate, UIScrollViewDelegate, iCarouselDataSource, iCarouselDelegate, UIViewControllerTransitioningDelegate, UISearchBarDelegate, SearchResultsTableViewControllerDelegate, DeleteAlertControllerDelegate {
    
    // MARK: Variables
    
    var selectedItem = 4
    
    var seriesDescription: UIView!
    
    var selectedMoodShows = [TVShow]()

    var searchController: UISearchController!
    
    var isShowingSearchBar = false
    
    var searchButton: UIBarButtonItem?
    
    var showToDelete = TVShow()
    
    var indexForShow: Int!
    
    var tooltipManager: JDFSequentialTooltipManager!
    
    let genres = ["🙀","👻", "😊", "😍", "⭐️", "💭", "🏆", "📜" , "🏃"]
    
     // MARK: Outlets
    
    @IBOutlet weak var seriesPosters: iCarousel!

    @IBOutlet weak var genrePicker: AKPickerView!

    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var menuButton: VBFPopFlatButton!
    
    @IBOutlet weak var tempView: UIView!
    
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        createTooltip()
        seriesPosters.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleMenu()

        genrePicker.delegate = self
        genrePicker.dataSource = self
        genrePicker.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.3)
        genrePicker.layer.cornerRadius = 25
        genrePicker.pickerViewStyle = .Flat
        genrePicker.interitemSpacing = 15
        genrePicker.reloadData()
        genrePicker.selectItem(4, animated: true)
        
        view.addSubview(genrePicker)
        
        seriesPosters.backgroundColor = UIColor.clearColor()
        seriesPosters.delegate = self
        seriesPosters.dataSource = self
        seriesPosters.type = .Rotary
        
        view.addSubview(seriesPosters)
    
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(RecommendationViewController.showAiringToday(_:)))
        leftSwipe.direction = .Left
        
        view.addGestureRecognizer(leftSwipe)
        
        let searchResultsController = self.storyboard?.instantiateViewControllerWithIdentifier("searchResults") as! SearchResultsTableViewController
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchResultsController.searchController = searchController
        searchResultsController.delegate = self
        searchController.searchResultsUpdater = searchResultsController
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchBarStyle = UISearchBarStyle.Minimal
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        
        searchButton = UIBarButtonItem(image: UIImage(named: "Search"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(RecommendationViewController.userDidSelectSearch))
        searchButton?.tintColor = UIColor.lightGrayColor()
        
        let textFieldInsideSearchBar = searchController.searchBar.valueForKey("searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.lightGrayColor()
        
        navigationItem.leftBarButtonItem = searchButton
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        hideSearchBar()
    }
    
    // MARK: Search Bar

    func userDidSelectSearch() {
        if isShowingSearchBar == false {
            navigationItem.leftBarButtonItem = nil
            navigationItem.titleView = searchController.searchBar
            searchController.searchBar.becomeFirstResponder()
            isShowingSearchBar = true
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        hideSearchBar()
    }
    
    func hideSearchBar() {
        navigationItem.titleView = nil
        navigationItem.title = "Recommendations"
        isShowingSearchBar = false
        navigationItem.leftBarButtonItem = searchButton
    }
    
    // MARK: Airing Today
    
    func showAiringToday(sender: UISwipeGestureRecognizer) {
        if sender.direction == .Left {
            let showController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AiringToday") as! AiringTodayViewController
            
            self.navigationController?.pushViewController(showController, animated: true)
        }
    }
    
    // MARK: Description Modal 
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentingAnimator()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissingAnimator()
    }
    
    // MARK: Picker View
    
    func numberOfItemsInPickerView(genrePicker: AKPickerView) -> Int {
        return self.genres.count
    }
    
    func pickerView(genrePicker: AKPickerView, titleForItem item: Int) -> String {
        return self.genres[item]
    }
    
    func pickerView(pickerView: AKPickerView, didSelectItem item: Int) {
        
        selectedItem = item
        
        let emojiRelation = Mood.MoodEmojiRelation(rawValue: genres[item])
        
        if item != 4 {
            
            genreLabel.text = emojiRelation?.moodName()
            emojiRelation?.shows({ (response) -> () in
                switch response {
                case .Success(let shows):
                    self.selectedMoodShows = shows
                    self.seriesPosters.reloadData()
                case .Failure(let error):
                    print(error, terminator: "")
                }
            })
            
        } else {
            genreLabel.text = emojiRelation?.moodName()
            UserLikedShows.getLikedShows { (response) -> Void in
                
                switch response {
                case .Success(let likedShows):
                    self.selectedMoodShows = likedShows
                    self.seriesPosters.reloadData()
                    
                case .Failure(let error):
                    print(error, terminator: "")
                }
                
            }
            
        }
    }
    
    // MARK: Carousel
    
    func numberOfItemsInCarousel(carousel: iCarousel!) -> Int
    {
        return selectedMoodShows.count
    }
    
    func carousel(carousel: iCarousel!, viewForItemAtIndex index: Int, reusingView view: UIView!) -> UIView!
    {
        
        var tempView : UIView?
        
        let height = self.seriesPosters.bounds.height
        
        let width = (height * 260) / 370
        
        if (view == nil) {
            tempView = UIView(frame: CGRectMake((self.seriesPosters.bounds.width - width) / 2, (self.seriesPosters.bounds.height - height) / 2, width, height))
        } else {
            
            tempView = view
        }
        
        let bg = UIImageView()
        bg.frame = tempView!.bounds
        bg.sd_setImageWithURL(selectedMoodShows[index].posterURL, placeholderImage: UIImage(named: "nopreview"))
        
       
        tempView!.addSubview(bg)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(RecommendationViewController.action(_:)))
        doubleTap.numberOfTapsRequired = 2
        tempView!.addGestureRecognizer(doubleTap)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(RecommendationViewController.action2(_:)))
        tempView!.addGestureRecognizer(longPress)
        
        tempView!.tag = index
        
        return tempView
    }
    
    
    func carousel(carousel: iCarousel!, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat
    {

        if (option == .Spacing)
        {
            return value * 1.05
        }
        
        return value
    }
    
    // MARK: Gesture Recognizer Actions
    
    func action(gestureRecognizer: UIGestureRecognizer) {
        
        let showDes = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ShowDescription") as! DescriptionViewController
        showDes.currentShow = selectedMoodShows[gestureRecognizer.view!.tag]
        showDes.modalPresentationStyle = UIModalPresentationStyle.Custom
        showDes.transitioningDelegate = self
        presentViewController(showDes, animated: true, completion: nil)
        
    }
    
    func action2(gestureRecognizer: UILongPressGestureRecognizer) {
       
        if gestureRecognizer.state == .Began {
            showToDelete = selectedMoodShows[gestureRecognizer.view!.tag]
            indexForShow = gestureRecognizer.view!.tag
            
            if selectedItem == 4 {
                deletePopup()
            }
            
        }
        
    }
    
    // MARK: Alert Controller
    
    func deletePopup() {
        let deleteAlert = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DeleteAlert") as! DeleteAlertViewController
        
        deleteAlert.currentDelegate = self
        deleteAlert.modalPresentationStyle = UIModalPresentationStyle.Custom
        deleteAlert.transitioningDelegate = self
        presentViewController(deleteAlert, animated: true, completion: nil)
            
    }
    
    func userDidPressDelete() {
        let parseShow = UserLikedShows(withoutDataWithObjectId: showToDelete.parseObjectId)
        parseShow.deleteInBackgroundWithBlock { (success, error) -> Void in
            
            if let error = error {
                print(error, terminator: "")
            } else {
                self.selectedMoodShows.removeAtIndex(self.indexForShow)
                self.seriesPosters.reloadData()
                print("show deleted", terminator: "")
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    // MARK: Tooltip
    
    func createTooltip() {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if userDefaults.boolForKey(hasShownRecommendationsIntstructionsKey) == false {
            
            self.view.layoutIfNeeded()
            
            tooltipManager = JDFSequentialTooltipManager(hostView: self.view)
            tooltipManager.addTooltipWithTargetView(genrePicker, hostView: self.view, tooltipText: "To dismiss an instruction, tap inside it.", arrowDirection: JDFTooltipViewArrowDirection.Up, width: 250.0)
            tooltipManager.addTooltipWithTargetView(genrePicker, hostView: self.view, tooltipText: "Browse  recommendations by mood.", arrowDirection: JDFTooltipViewArrowDirection.Up, width: 250.0)
            tooltipManager.addTooltipWithTargetView(seriesPosters, hostView: self.view, tooltipText: "Double tap to get a show description.", arrowDirection: JDFTooltipViewArrowDirection.Up, width: 250.0)
            tooltipManager.addTooltipWithTargetView(seriesPosters, hostView: self.view, tooltipText: "Long press to delete a recommendation.", arrowDirection: JDFTooltipViewArrowDirection.Up, width: 250.0)
            tooltipManager.addTooltipWithTargetView(tempView, hostView: self.view, tooltipText: "Swipe left to see which shows are airing today.", arrowDirection: JDFTooltipViewArrowDirection.Down, width: 250.0)
            
            
            tooltipManager.setFontForAllTooltips(UIFont(name: "OpenSans", size: 15))
            tooltipManager.setBackgroundColourForAllTooltips(UIColor.whiteColor().colorWithAlphaComponent(0.9))
            tooltipManager.setTextColourForAllTooltips(UIColor.blackColor())
        
            tooltipManager.showNextTooltip()
            userDefaults.setBool(true, forKey: hasShownRecommendationsIntstructionsKey)
            
        }
        
    }

    
    // MARK: Menu
    
    func styleMenu() {
        
        menuButton.currentButtonType = FlatButtonType.buttonMenuType
        menuButton.currentButtonStyle = FlatButtonStyle.buttonPlainStyle
        menuButton.lineThickness = 2
        menuButton.tintColor = UIColor.whiteColor()
    }
   
}

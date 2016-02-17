//
//  SearchResultsTableViewController.swift
//  Surfies
//
//  Created by Barbara Brina on 8/7/15.
//  Copyright (c) 2015 Barbara Brina. All rights reserved.
//

import UIKit

protocol SearchResultsTableViewControllerDelegate: class {
    func hideSearchBar()
}

class SearchResultsTableViewController: UITableViewController, UISearchResultsUpdating, UIViewControllerTransitioningDelegate, DescriptionViewControllerDelegate {

    // MARK: Variables
    
    var searchController: UISearchController?
    
    var delegate: SearchResultsTableViewControllerDelegate?
    
    var searchedShow = [TVShow]()
    
    // MARK: iOS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = false

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var token: dispatch_once_t = 0
        dispatch_once(&token) { () -> Void in
            self.tableView.contentInset = UIEdgeInsetsZero
        }
    }

    // MARK: Search Results
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText: String! = searchController.searchBar.text
        
        if (searchText != nil) && (searchText.characters.count > 2) {
            
            TVShow.getSearchShowByTitle(searchText, response: { (response) -> () in
                switch response {
                case .Failure(let error):
                    print(error)
                    
                case .Success(let searchedTVShow):
                    self.searchedShow = searchedTVShow
                    self.tableView.reloadData()
                    
                }
            })
        }
        
    }

    // MARK: Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return searchedShow.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath) as! SearchTableViewCell
        cell.showName.text = searchedShow[indexPath.row].originalName
        cell.showImage.sd_setImageWithURL(searchedShow[indexPath.row].posterURL, placeholderImage: UIImage(named: "nopreview"))
        cell.showImage.contentMode = UIViewContentMode.ScaleAspectFit

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let showDes = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ShowDescription") as! DescriptionViewController
        
        showDes.currentShow = searchedShow[indexPath.row]
        showDes.modalPresentationStyle = UIModalPresentationStyle.Custom
        showDes.transitioningDelegate = self
        showDes.currentDelegate = self
        presentViewController(showDes, animated: true, completion: nil)
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: Description Modal 

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentingAnimator()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissingAnimator()
    }
    
    func userDidCloseModal() {
        searchController?.active = false
        delegate?.hideSearchBar()
    }

}

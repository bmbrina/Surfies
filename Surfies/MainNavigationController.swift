//
//  MainNavigationController.swift
//  Surfies
//
//  Created by Barbara Brina on 8/6/15.
//  Copyright (c) 2015 Barbara Brina. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController, menuViewControllerDelegate {

    let SurfiesStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        navigationBar.translucent = false
    }
    
    func didPressDiscover() {
        self.dismissViewControllerAnimated(true, completion: nil)
        let discoverViewController = SurfiesStoryboard.instantiateViewControllerWithIdentifier("Discover") 
        setViewControllers([discoverViewController], animated: false)
        
        
    }
    
    func didPressRecommendations() {
        self.dismissViewControllerAnimated(true, completion: nil)
        let recommendationsViewController = SurfiesStoryboard.instantiateViewControllerWithIdentifier("Recommendations") 
        setViewControllers([recommendationsViewController], animated: false)
        
    }
    
    func didPressMySeries() {
        self.dismissViewControllerAnimated(true, completion: nil)
        let mySeriesViewController = SurfiesStoryboard.instantiateViewControllerWithIdentifier("MySeries") 
        setViewControllers([mySeriesViewController], animated: false)
        
    }
    
    func didPressSettings() {
        self.dismissViewControllerAnimated(true, completion: nil)
        let settingsViewController = SurfiesStoryboard.instantiateViewControllerWithIdentifier("Settings") 
        setViewControllers([settingsViewController], animated: false)
        
    }
}

//
//  MenuViewController.swift
//  Surfies
//
//  Created by Barbara Brina on 7/22/15.
//  Copyright (c) 2015 Barbara Brina. All rights reserved.
//

import UIKit
import VBFPopFlatButton

protocol menuViewControllerDelegate: class {
    
    func didPressSettings()
    func didPressDiscover()
    func didPressRecommendations()
    func didPressMySeries()
}

class MenuViewController: UIViewController {
    
    // MARK: Variables
    
    weak var delegate: menuViewControllerDelegate?
    
    // MARK: Outlets
    
    @IBOutlet weak var closeButton: VBFPopFlatButton!
    
    // MARK: Actions
    
    @IBAction func closeMenu(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    
    @IBAction func pressedSettings(sender: AnyObject) {
        self.delegate?.didPressSettings()
    }
    
    @IBAction func pressedMySeries(sender: AnyObject) {
        self.delegate?.didPressMySeries()
    }
    
    @IBAction func pressedRecommendations(sender: AnyObject) {
        self.delegate?.didPressRecommendations()
    }
    
    @IBAction func pressedDiscover(sender: AnyObject) {
        self.delegate?.didPressDiscover()
    }
    
    // MARK: iOS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeButton.currentButtonType = FlatButtonType.buttonCloseType
        closeButton.currentButtonStyle = FlatButtonStyle.buttonPlainStyle
        closeButton.lineThickness = 2
        closeButton.tintColor = UIColor.whiteColor()
        
    }
    

}

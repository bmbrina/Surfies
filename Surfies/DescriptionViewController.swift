//
//  DescriptionViewController.swift
//  
//
//  Created by Barbara Brina on 7/20/15.
//
//

import UIKit
import DOFavoriteButton
import QuartzCore
import JDFTooltips

protocol DescriptionViewControllerDelegate: class {
    
    func userDidCloseModal()
    
}

class DescriptionViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    // MARK: Variables

    var currentShow: TVShow?
    
    var isASavedShow: Bool!
    
    weak var currentDelegate: DescriptionViewControllerDelegate?
    
    var tooltipManager: JDFSequentialTooltipManager!
    
    
    
    // MARK: Outlets
    
    @IBOutlet weak var showName: UILabel!
    
    @IBOutlet weak var showDescription: UITextView!
    
    @IBOutlet weak var descriptionView: UIView!
    
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var saveButton: DOFavoriteButton!
    
    @IBOutlet weak var tempView: UIView!
    
    // MARK: Actions
    
    @IBAction func closeModal(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: iOS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGradient()
        

        descriptionView.layer.cornerRadius = 10
        
        saveButton.addTarget(self, action: #selector(DescriptionViewController.tapped(_:)), forControlEvents: .TouchUpInside)
        
        if let currentShow = currentShow {
            
            UserSavedShows.isSaved(currentShow.serieId, response: { (response) -> Void in
                switch response {
                case .Success(let isSaved):
                    self.isASavedShow = isSaved
                    
                    if self.isASavedShow == true {
                        self.saveButton.selected = true
                    } else {
                        self.saveButton.selected = false
                    }
                    
                case .Failure(let error):
                    print(error, terminator: "")
                }
            })
            
            showName.text = currentShow.originalName
            showDescription.text = currentShow.description
        
        }
        
        showDescription.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 65, right: 0)
        
       
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        createTooltip()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var token: dispatch_once_t = 0
        dispatch_once(&token) { () -> Void in
            self.showDescription.contentOffset = CGPointZero
        }
    }
    
    // MARK: Gradient

    func addGradient() {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = gradientView.bounds
        
        let color1 = UIColor.clearColor().CGColor
        let color2 = UIColor.blackColor().CGColor
        let arrayColors = [color1, color2]
        
        gradient.colors = arrayColors
        
        gradientView.layer.addSublayer(gradient)
    }
    
    // MARK: DOFavoriteButton
    
    func tapped(sender: DOFavoriteButton) {
        
        if sender.selected {
            sender.deselect()
        } else {
            UserSavedShows.userSavedShow(currentShow!, response: { (response) -> Void in
                switch response {
                case .Failure(let error):
                    print(error)
                    
                case .Success(_):
                    print("saved success")
                }
            })
            sender.select()
        }
        
    }
    
    // MARK: Tooltip
    
    func createTooltip() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if userDefaults.boolForKey(hasShownDescriptionIntrstructionsKey) == false {
            
            tooltipManager = JDFSequentialTooltipManager(hostView: self.view)
            tooltipManager.addTooltipWithTargetView(saveButton, hostView: self.view.subviews.first as UIView!, tooltipText: "Tap to save a TV Show to your series.", arrowDirection: JDFTooltipViewArrowDirection.Down, width: 200.0)
            
            
            tooltipManager.setFontForAllTooltips(UIFont(name: "OpenSans", size: 15))
            tooltipManager.setBackgroundColourForAllTooltips(UIColor.whiteColor().colorWithAlphaComponent(0.9))
            tooltipManager.setTextColourForAllTooltips(UIColor.blackColor())
            
            tooltipManager.showAllTooltips()
            userDefaults.setBool(true, forKey: hasShownDescriptionIntrstructionsKey)
            
        }
    }
    

}

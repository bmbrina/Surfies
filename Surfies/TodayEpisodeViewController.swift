//
//  TodayEpisodeViewController.swift
//  Surfies
//
//  Created by Barbara Brina on 2/2/16.
//  Copyright © 2016 Barbara Brina. All rights reserved.
//

import UIKit
import DOFavoriteButton
import QuartzCore

class TodayEpisodeViewController: UIViewController {

    // MARK: Variables
    
    // MARK: Outlets
    
    @IBOutlet weak var episodeImage: UIImageView!
    
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var episodeDescription: UITextView!
    
    @IBOutlet weak var gradientView2: UIView!
    
    @IBOutlet weak var watchedButton: DOFavoriteButton!
    
    
    // MARK: iOS
    
    override func viewDidLoad() {
        super.viewDidLoad()

        watchedButton.addTarget(self, action: #selector(TodayEpisodeViewController.tapped(_:)), forControlEvents: .TouchUpInside)
        
        addGradient()
        addGradienToTextView()
        
        episodeDescription.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 65, right: 0)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(TodayEpisodeViewController.goBack(_:)))
        
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(rightSwipe)
        
        updateScreen()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        let backButton = UIBarButtonItem(image: UIImage(named: "Back"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(TodayEpisodeViewController.didSelectBack))
        
        self.navigationItem.leftBarButtonItem = backButton
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationController?.navigationBar.translucent = true
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
    
    // MARK: Back
    
    func goBack(sender: UISwipeGestureRecognizer) {
        if sender.direction == .Right {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func didSelectBack() {
        
        self.navigationController?.popViewControllerAnimated(true)
    }

    
    // MARK: Episode info
    
    func updateScreen() {
        episodeImage.image = UIImage(named: "sample")
        episodeDescription.text = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc."
        self.navigationItem.title = "Lorem ipsum"
    }
    
    // MARK: DOFavoriteButton
    
    func tapped(sender: DOFavoriteButton) {
        if sender.selected {
            sender.deselect()
        } else {
            sender.select()
        }
    }

}

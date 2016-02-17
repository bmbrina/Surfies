//
//  DeleteAlertViewController.swift
//  Surfies
//
//  Created by Barbara Brina on 9/7/15.
//  Copyright (c) 2015 Barbara Brina. All rights reserved.
//

import UIKit

protocol DeleteAlertControllerDelegate: class {
    
    func userDidPressDelete()
    
}

class DeleteAlertViewController: UIViewController, UIViewControllerTransitioningDelegate {

    // MARK: Variables
    
    var currentDelegate: DeleteAlertControllerDelegate?
    
    // MARK: Outlets
    
    @IBOutlet weak var popUpView: UIView!
    
    // MARK: Actions
    
    @IBAction func deleteButton(sender: AnyObject) {
        self.currentDelegate?.userDidPressDelete()
    }
    
    
    @IBAction func cancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: iOS
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popUpView.layer.cornerRadius = 10
    }
    
    // MARK: Delete

}

//
//  AvatarView.swift
//  AvatarView
//
//  Created by ChristianEnevoldsen on 08/06/15.
//  Copyright (c) 2015 che. All rights reserved.
//

import UIKit

public class AvatarView: UIView {
    
    // The UIImageView that displays the avatar
    public let imageView = UIImageView()
    
    // Responsible for drawing the border
    // Do not set the strokeColor or lineWidth on this. Instead use the API
    // see borderColor, borderWidth
    public let borderLayer = CAShapeLayer()
    
    // The images mask
    private let imageMask = CAShapeLayer()
    
    // The image / avatar
    public var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    // The border color for the avatar
    // Setting the borderColor updates the borderLayers strokeColor
    public var borderColor: UIColor? {
        didSet {
            borderLayer.strokeColor = borderColor?.CGColor
        }
    }
    
    // The border width for the avatar
    // Setting the borderWidth updates the borderLayers lineWidth
    public var borderWidth: CGFloat = 0 {
        didSet {
            borderLayer.lineWidth = borderWidth * 2
        }
    }
    
    public init(image: UIImage) {
        self.image = image
        
        let imageSize = max(image.size.width, image.size.height)
        super.init(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        
        setup()
        setupDefaults()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        setupDefaults()
    }
    
    // Sets up the view after it's initialized
    private func setup() {
        layer.addSublayer(borderLayer)
        addSubview(imageView)
        
        // Smoothens the border
        borderLayer.contentsScale = 2.0 * UIScreen.mainScreen().scale
        
        // Explicitly set the image
        imageView.image = image
        
        // Mask the image
        imageView.layer.mask = imageMask
    }
    
    // Sets up the default colors etc.
    func setupDefaults() {
        // Keep the images dimensions
        imageView.contentMode = .ScaleAspectFill
        
        // Set default border widths
        borderWidth = 1.0
        borderColor = .whiteColor()
    }
    
    // Layouts the subview
    public override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    
    // Layouts the layers
    public override func layoutSublayersOfLayer(layer: CALayer) {
        super.layoutSublayersOfLayer(layer)
        
        // Makes room for the the border
        let insetsSize = borderWidth
        let rectInsets = CGRectInset(bounds, insetsSize, insetsSize)
        
        // Update the path to fit the frame
        imageMask.path = UIBezierPath(ovalInRect: rectInsets).CGPath
        borderLayer.path = imageMask.path
        borderLayer.frame = bounds
    }
    
}

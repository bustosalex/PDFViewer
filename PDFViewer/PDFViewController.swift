//
//  PDFViewController.swift
//  PDFViewer
//
//  Created by Alexander Bustos on 12/20/16.
//  Copyright © 2016 Alexander Bustos. All rights reserved.
//

import UIKit
import CoreGraphics

class PDFViewController: UIViewController {
    var imageView: UIImageView?
    var pdfPageImage: UIImage?
    var chapter: Int?
    var index: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView = UIImageView()
        view.addSubview(imageView!)
        imageView?.contentMode = .scaleAspectFit
        imageView?.image = pdfPageImage
        imageView?.frame = view.bounds
        imageView?.bindFrameToSuperviewBounds()
        if let number = chapter {
            print("Showing chapter \(number) page \(index!)")
        }
        // Set the image
        // Create tap gesture recognizer on top of the image
        imageView?.isUserInteractionEnabled = true
        
    }
    

}

extension UIView {
    
    /// Adds constraints to this `UIView` instances `superview` object to make sure this always has the same size as the superview.
    /// Please note that this has no effect if its `superview` is `nil` – add this `UIView` instance as a subview before calling this.
    func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
    }
    
}

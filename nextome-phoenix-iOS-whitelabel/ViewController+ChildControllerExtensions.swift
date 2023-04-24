//
//  ViewController+ChildControllerExtensions.swift
//  nextome-phoenix-iOS-whitelabel
//
//  Created by Anna Labellarte on 28/03/23.
//

import Foundation
import UIKit

extension MapViewController{
    
    func openIndoorMap(){
        if currentVC != indoorMapViewController {
            remove(asChildViewController: outdoorMapViewController)
            add(asChildViewController: indoorMapViewController)
        }
    }
    
    func openOutdoorMap(){
        if currentVC != outdoorMapViewController {
            remove(asChildViewController: indoorMapViewController)
            add(asChildViewController:outdoorMapViewController)
        }
    }

    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)

        // Add Child View as Subview
        childContainerView.addSubview(viewController.view)

        // Configure Child View
        viewController.view.frame = childContainerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Notify Child View Controller
        viewController.didMove(toParent: self)
        currentVC = viewController
    }

    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)

        // Remove Child View From Superview
        viewController.view.removeFromSuperview()

        // Notify Child View Controller
        viewController.removeFromParent()
        currentVC = nil
    }
}

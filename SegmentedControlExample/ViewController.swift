//
//  ViewController.swift
//  SegmentedControlExample
//
//  Created by Dennis Pashkov on 5/23/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import CoreGraphics
import class SegmentedControl.SegmentedControl
import protocol SegmentedControl.SegmentedControlDataSource
import protocol SegmentedControl.SegmentedControlDelegate
import class SegmentedControl.SegmentedItem
import struct SegmentedControl.SegmentedItemSettings
import class UIKit.NSLayoutConstraint.NSLayoutConstraint
import class UIKit.UIScrollView.UIScrollView
import protocol UIKit.UIScrollView.UIScrollViewDelegate
import class UIKit.UIView.UIView
import class UIKit.UIViewController.UIViewController

private let kHeaderDefaultHeight: CGFloat = 65.0
private let kHeaderMaximizedHeight: CGFloat = 150.0

/// Example view controller.
internal class ViewController: UIViewController {

    //MARK: - Private -
    //MARK: Properties
    
    @IBOutlet private weak var headerHeightConstraint: NSLayoutConstraint?
    
    @IBOutlet fileprivate weak var scrollView: UIScrollView?
    @IBOutlet fileprivate weak var segmentedControl: SegmentedControl? {
        
        didSet {
            
            self.segmentedControl?.items = [
            
                SegmentedItem(normalSettings: SegmentedItemSettings(icon: #imageLiteral(resourceName: "red"), stripeColor: .red),
                              selectedSettings: SegmentedItemSettings(icon: #imageLiteral(resourceName: "red"), stripeColor: .red),
                              contentAlignment: .top,
                              hasCustomView: false),
                SegmentedItem(normalSettings: SegmentedItemSettings(icon: #imageLiteral(resourceName: "grey"), stripeColor: .green),
                              selectedSettings: SegmentedItemSettings(icon: #imageLiteral(resourceName: "green"), stripeColor: .green),
                              contentAlignment: .center,
                              hasCustomView: true),
                SegmentedItem(normalSettings: SegmentedItemSettings(icon: #imageLiteral(resourceName: "grey"), stripeColor: .blue),
                              selectedSettings: SegmentedItemSettings(icon: #imageLiteral(resourceName: "blue"), stripeColor: .blue),
                              contentAlignment: .bottom,
                              hasCustomView: false),
                SegmentedItem(normalSettings: SegmentedItemSettings(icon: #imageLiteral(resourceName: "grey"), stripeColor: .red),
                              selectedSettings: SegmentedItemSettings(icon: #imageLiteral(resourceName: "red"), stripeColor: .red),
                              contentAlignment: .center,
                              hasCustomView: true),
                SegmentedItem(normalSettings: SegmentedItemSettings(icon: #imageLiteral(resourceName: "grey"), stripeColor: .green),
                              selectedSettings: SegmentedItemSettings(icon: #imageLiteral(resourceName: "green"), stripeColor: .green),
                              contentAlignment: .top,
                              hasCustomView: false),
                SegmentedItem(normalSettings: SegmentedItemSettings(icon: #imageLiteral(resourceName: "grey"), stripeColor: .blue),
                              selectedSettings: SegmentedItemSettings(icon: #imageLiteral(resourceName: "blue"), stripeColor: .blue),
                              contentAlignment: .center,
                              hasCustomView: true)
            ]
            
            self.segmentedControl?.dataSource = self
        }
    }
    
    //MARK: Methods
    
    @IBAction private func changeHeaderSizeButtonTouchUpInside(_ sender: Any) {
        
        guard let nonnullHeaderHeightConstraint = self.headerHeightConstraint else { return }
        
        if nonnullHeaderHeightConstraint.constant == kHeaderDefaultHeight {
            
            nonnullHeaderHeightConstraint.constant = kHeaderMaximizedHeight
        }
        else {
            
            nonnullHeaderHeightConstraint.constant = kHeaderDefaultHeight
        }
        
        UIView.animate(withDuration: 0.3) { 
            
            self.view.tap_layout()
        }
    }
}

// MARK: - UIScrollViewDelegate
extension ViewController: UIScrollViewDelegate {
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.segmentedControl?.selectedSegment = scrollView.contentOffset.x / scrollView.bounds.width
    }
}

// MARK: - SegmentedControlDataSource
extension ViewController: SegmentedControlDataSource {
    
    func segmentedControl(_ segmentedControl: SegmentedControl, customViewFor item: SegmentedItem) -> UIView? {
        
        guard let index = self.segmentedControl?.items.index(of: item) else { return nil }
        
        guard index == 1 else { return nil }
        
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0))
        view.backgroundColor = .black
        view.tap_cornerRadius = 25
        
        return view
    }
}

// MARK: - SegmentedControlDelegate
extension ViewController: SegmentedControlDelegate {
    
    internal func segmentedControl(_ segmentedControl: SegmentedControl, didSelectSegment segment: CGFloat) {
        
        guard let nonnullScrollView = self.scrollView else { return }
        
        nonnullScrollView.setContentOffset(CGPoint(x: segment * nonnullScrollView.bounds.width, y: nonnullScrollView.contentOffset.y), animated: true)
    }
}

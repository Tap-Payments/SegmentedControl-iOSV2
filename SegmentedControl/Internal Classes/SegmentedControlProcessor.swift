//
//  SegmentedControlProcessor.swift
//  SegmentedControl
//
//  Created by Dennis Pashkov on 5/23/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import CoreGraphics
import TapAdditionsKitV2
import class UIKit.NSLayoutConstraint.NSLayoutConstraint
import class UIKit.UICollectionView.UICollectionView
import protocol UIKit.UICollectionView.UICollectionViewDataSource
import protocol UIKit.UICollectionView.UICollectionViewDelegate
import protocol UIKit.UICollectionView.UICollectionViewDelegateFlowLayout
import class UIKit.UICollectionViewCell.UICollectionViewCell
import class UIKit.UICollectionViewLayout.UICollectionViewLayout
import class UIKit.UIColor.UIColor
import class UIKit.UINib.UINib
import class UIKit.UIScrollView.UIScrollView
import protocol UIKit.UIScrollView.UIScrollViewDelegate
import class UIKit.UIView.UIView

/// Collection View helper class for SegmentedControl.
internal class SegmentedControlProcessor: NSObject {
    
    //MARK: - Internal -
    //MARK: Properties
    
    /// Stripe height.
    internal var stripeHeight: CGFloat = 5.0 {
        
        didSet {
            
            guard self.stripeViewHeightConstraint.constant != self.stripeHeight else { return }
            
            self.stripeViewHeightConstraint.constant = self.stripeHeight
            
            self.segmentedControl.tap_layout()
        }
    }
    
    /// Minimal distance from collection view to stripe.
    internal var minimalTopDistanceToStripe: CGFloat = 0.0 {
        
        didSet {
            
            guard self.stripeViewTopOffsetConstraint.constant != self.minimalTopDistanceToStripe else { return }
            
            self.stripeViewTopOffsetConstraint.constant = self.minimalTopDistanceToStripe
            
            self.segmentedControl.tap_layout()
        }
    }
    
    //MARK: Methods
    
    /// Reloads segmented control.
    internal func reload() {
        
        self.collectionView.reloadData()
        self.collectionView.collectionViewLayout.prepare()
        
        self.updateIndex()
    }
    
    /// Updates segmented control selection.
    internal func updateIndex() {
        
        self.updateVisibleCellsAppearanceForSelectedSegment()
        
        let roundedSegment = Int(round(self.segmentedControl.selectedSegment))
        
        if self.collectionView.numberOfItems(inSection: 0) > roundedSegment {
            
            if let frame = self.collectionView.layoutAttributesForItem(at: IndexPath(item: roundedSegment, section: 0))?.frame {
                
                let centerX = frame.midX
                let minimalContentOffset = CGFloat(0.0)
                let maximalContentOffset = self.collectionView.tap_maximalContentOffset.x
                let desiredContentOffset = min(max(centerX - 0.5 * self.collectionView.bounds.width, minimalContentOffset), maximalContentOffset)
                
                let animations = {
                    
                    self.collectionView.contentOffset = CGPoint(x: desiredContentOffset, y: self.collectionView.contentOffset.y)
                }
                
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [.beginFromCurrentState, .curveEaseInOut], animations: animations, completion: nil)
            }
        }
        
        self.updateStripe()
    }
    
    /// Returns the view for specified item.
    ///
    /// - Parameter item: Item to find the view.
    /// - Returns: View.
    internal func segmentView(for item: SegmentedItem) -> UIView? {
    
        guard let index = self.segmentedControl.items.index(of: item) else { return nil }
        
        return self.collectionView.cellForItem(at: IndexPath(item: index, section: 0))
    }
    
    /// Updates constraints of the stripe view.
    internal func updateStripeViewConstraints() {
        
        var requiresLayout = false
        self.updateStripeViewConstraints(&requiresLayout)
    }
    
    /// Updates constraints of the stripe view.
    ///
    /// - Parameter requiresLayout: Boolean parameter that determines whether the view requires layout after the constraints change.
    internal func updateStripeViewConstraints(_ requiresLayout: inout Bool) {
        
        let stripeWidth = self.cellWidth
        let spacePerItem = stripeWidth + self.spaceBetweenCells
        
        let leftOffset = self.segmentedControl.selectedSegment * spacePerItem - self.collectionView.contentOffset.x
        
        requiresLayout = false
        if self.stripeViewLeftOffsetConstraint.constant != leftOffset {
            
            requiresLayout = true
            self.stripeViewLeftOffsetConstraint.constant = leftOffset
        }
        
        if self.stripeViewWidthConstraint.constant != stripeWidth {
            
            requiresLayout = true
            self.stripeViewWidthConstraint.constant = stripeWidth
        }
    }
    
    //MARK: - FilePrivate -
    
    fileprivate struct SegmentedCellReuseIdentifiers {
        
        fileprivate static let normal = SegmentedItemCollectionViewCell.tap_className
        fileprivate static let withCustomView = SegmentedItemCollectionViewCell.tap_className + "_with_custom_view"
    }
    
    //MARK: Properties
    
    @IBOutlet fileprivate weak var segmentedControl: SegmentedControl!
    
    @IBOutlet fileprivate weak var collectionView: UICollectionView! {
        
        didSet {
            
            let cellNib = UINib(nibName: SegmentedItemCollectionViewCell.tap_className, bundle: Bundle(for: type(of: self)))
            let reuseIdentifiers: [String] = [SegmentedCellReuseIdentifiers.normal, SegmentedCellReuseIdentifiers.withCustomView]
            
            for identifier in reuseIdentifiers {
                
                self.collectionView.register(cellNib, forCellWithReuseIdentifier: identifier)
            }
        }
    }
    
    @IBOutlet fileprivate weak var stripeViewLeftOffsetConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var stripeViewWidthConstraint: NSLayoutConstraint!
    
    fileprivate var cellWidth: CGFloat {
        
        guard let control = self.segmentedControl else { return 0.0 }
        
        var itemsCount = control.items.count
        if itemsCount == 0 {
            
            itemsCount = 1
        }
        
        return tap_clamp(value: control.bounds.width / CGFloat(itemsCount),
                     low: control.minimalSegmentWidth,
                     high: control.maximalSegmentWidth)
    }
    
    fileprivate var cellSize: CGSize {
        
        return CGSize(width: self.cellWidth,
                      height: self.collectionView.bounds.height)
    }
    
    fileprivate var spaceBetweenCells: CGFloat {
        
        if self.segmentedControl.spreadsSegmentsAcrossBounds {
            
            let itemsCount = CGFloat(self.segmentedControl.items.count)
            
            guard itemsCount > 0.0 else { return 0.0 }
            
            let freeSpace = max(self.segmentedControl.bounds.width - itemsCount * self.cellWidth, 0.0)
            let result = freeSpace / (itemsCount - 1.0)
            return result
        }
        else {
            
            return 0.0
        }
    }
    
    //MARK: Methods
    
    fileprivate func updateStripe() {
        
        var requiresLayout = false
        self.updateStripeViewConstraints(&requiresLayout)
        
        if requiresLayout {
            
            self.stripeView.tap_layout()
        }
        
        self.updateStripeColor()
    }
    
    fileprivate func updateVisibleCells() {
        
        for cell in self.collectionView.visibleCells {
            
            guard let indexPath = self.collectionView.indexPath(for: cell), let itemCell = cell as? SegmentedItemCollectionViewCell else { continue }
            let item = self.segmentedControl.items[indexPath.item]
            
            self.updateCell(itemCell, at: indexPath, with: item)
        }
    }
    
    fileprivate func updateVisibleCellsAppearanceForSelectedSegment() {
        
        for cell in self.collectionView.visibleCells {
            
            guard let indexPath = self.collectionView.indexPath(for: cell), let itemCell = cell as? SegmentedItemCollectionViewCell else { continue }
            let item = self.segmentedControl.items[indexPath.item]
            
            self.updateCellAppearanceForSelectedSegment(itemCell, at: indexPath, with: item)
        }
    }
    
    fileprivate func updateCell(_ cell: SegmentedItemCollectionViewCell, at indexPath: IndexPath, with item: SegmentedItem) {
        
        cell.normalImage = item.normalSettings.icon
        cell.selectedImage = item.selectedSettings.icon
        cell.customContentView = item.hasCustomView ? self.segmentedControl.dataSource?.segmentedControl(self.segmentedControl, customViewFor: item) : nil
        cell.minimalTransformableScale = self.segmentedControl.segmentsMagnificationEnabled ? type(of: cell).defaultMinimalScale : 1.0
        cell.maximalTransformableScale = self.segmentedControl.segmentsMagnificationEnabled ? type(of: cell).defaultMaximalScale : 1.0
        cell.shouldUseOnlyNormalImage = item.hasSingleImageForBothStates
        cell.contentAlignment = item.contentAlignment
        
        self.updateCellAppearanceForSelectedSegment(cell, at: indexPath, with: item)
    }
    
    fileprivate func updateCellAppearanceForSelectedSegment(_ cell: SegmentedItemCollectionViewCell, at indexPath: IndexPath, with item: SegmentedItem) {
        
        let active = 1.0 - abs(self.segmentedControl.selectedSegment - CGFloat(indexPath.item))
        
        cell.active = active
        cell.transformableViewSize = CGSize.tap_interpolate(start: item.normalSettings.iconSize, finish: item.selectedSettings.iconSize, progress: active).tap_fit(to: self.cellSize)
    }
    
    //MARK: - Private -
    //MARK: Properties
    
    @IBOutlet private weak var stripeViewTopOffsetConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var stripeView: UIView!
    @IBOutlet private weak var stripeViewHeightConstraint: NSLayoutConstraint!
    
    //MARK: Methods
    
    private func updateStripeColor() {
        
        var stripeColor: UIColor = .clear
        guard self.segmentedControl.items.count > 0 else {
            
            self.stripeView.layer.backgroundColor = stripeColor.cgColor
            return
        }
        
        let flooredFirstSegment = CGFloat(floor(self.segmentedControl.selectedSegment))
        let firstIndex = Int(flooredFirstSegment)
        
        if flooredFirstSegment == self.segmentedControl.selectedSegment {
            
            stripeColor = self.segmentedControl.items[firstIndex].normalSettings.stripeColor
        }
        else {
            
            stripeColor = UIColor.tap_interpolate(start: self.segmentedControl.items[firstIndex].normalSettings.stripeColor,
                                              finish: self.segmentedControl.items[firstIndex + 1].normalSettings.stripeColor,
                                              progress: self.segmentedControl.selectedSegment - flooredFirstSegment)
        }
        
        self.stripeView.layer.backgroundColor = stripeColor.cgColor
    }
}

// MARK: - UIScrollViewDelegate
extension SegmentedControlProcessor: UIScrollViewDelegate {
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.updateStripe()
    }
}

// MARK: - UICollectionViewDataSource
extension SegmentedControlProcessor: UICollectionViewDataSource {
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.segmentedControl.items.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = self.segmentedControl.items[indexPath.item]
        let reuseIdentifier = item.hasCustomView ? SegmentedCellReuseIdentifiers.withCustomView : SegmentedCellReuseIdentifiers.normal
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    }
}

// MARK: - UICollectionViewDelegate
extension SegmentedControlProcessor: UICollectionViewDelegate {
    
    internal func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let itemCell = cell as? SegmentedItemCollectionViewCell else {
            
            fatalError("Data source not configured.")
        }
        
        let item = self.segmentedControl.items[indexPath.item]
        
        self.updateCell(itemCell, at: indexPath, with: item)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: false)
        self.segmentedControl.delegate?.segmentedControl?(self.segmentedControl, didSelectSegment: CGFloat(indexPath.item))
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SegmentedControlProcessor: UICollectionViewDelegateFlowLayout {
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return self.spaceBetweenCells
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return self.cellSize
    }
}

// MARK: - SegmentedCollectionViewDelegate
extension SegmentedControlProcessor: SegmentedCollectionViewDelegate {
    
    internal func collectionViewBoundsChanged(_ collectionView: SegmentedCollectionView) {
        
        collectionView.collectionViewLayout.invalidateLayout()
        self.updateVisibleCellsAppearanceForSelectedSegment()
    }
}

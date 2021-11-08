//
//  SegmentedItemCollectionViewCell.swift
//  SegmentedControl
//
//  Created by Dennis Pashkov on 5/23/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import TapAdditionsKitV2

/// Segmented Item Collection View Cell.
internal class SegmentedItemCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Internal -
    //MARK: Properties

    internal static let defaultMinimalScale = SegmentedItemCollectionViewCellConstants.minimalScale
    internal static let defaultMaximalScale = SegmentedItemCollectionViewCellConstants.maximalScale
    
    /// Normal image.
    internal weak var normalImage: UIImage? {
        
        get {
            
            return self.normalImageView?.image
        }
        set {
            
            self.normalImageView?.image = newValue
        }
    }
    
    /// Selected image.
    internal weak var selectedImage: UIImage? {
        
        get {
            
            return self.selectedImageView?.image
        }
        set {
            
            self.selectedImageView?.image = newValue
        }
    }
    
    /// Custom content view.
    internal weak var customContentView: UIView? {
        
        get {
            
            return self.customView
        }
        set {
            
            if newValue != nil && newValue == self.customContentView && newValue?.superview != self.transformableView {
                
                guard let nonnullCustomView = newValue else { return }
                self.transformableView?.tap_addSubviewWithConstraints(nonnullCustomView, respectLanguageDirection: false)
                return
            }
            
            self.customContentView?.removeFromSuperview()
            
            if let nonnullCustomView = newValue {
                
                self.transformableView?.tap_addSubviewWithConstraints(nonnullCustomView, respectLanguageDirection: false)
                
                self.normalImageView?.isHidden = true
                self.selectedImageView?.isHidden = true
            }
            else {
                
                self.normalImageView?.isHidden = false
                self.selectedImageView?.isHidden = false
            }
            
            self.customView = newValue
        }
    }
    
    /// Transformable view size.
    internal var transformableViewSize: CGSize = CGSize(width: 50.0, height: 50.0) {
        
        didSet {
            
            self.transformableViewWidthConstraint?.constant = self.transformableViewSize.width
            self.transformableViewHeightConstraint?.constant = self.transformableViewSize.height
            
            self.layoutIfNeeded()
        }
    }
    
    /// Defines activity state: 0.0 - inactive, 1.0 - fully active.
    internal var active: CGFloat = 0.0 {
        
        didSet {
            
            let appliedActive = self.realActive
            
            self.updateTransform()
            self.updateImagesAlpha()
            
            if ( self.active != appliedActive ) {
                
                self.active = appliedActive
            }
        }
    }
    
    /// Minimal scale that can be applied to transformable view.
    internal var minimalTransformableScale: CGFloat = SegmentedItemCollectionViewCellConstants.minimalScale {
        
        didSet {
            
            self.updateTransform()
        }
    }
    
    /// Maximal scale that can be applied to transformable view
    internal var maximalTransformableScale: CGFloat = SegmentedItemCollectionViewCellConstants.maximalScale {
        
        didSet {
            
            self.updateTransform()
        }
    }
    
    /// Defines if single image should be used only.
    internal var shouldUseOnlyNormalImage: Bool = false {
        
        didSet {
            
            self.updateImagesAlpha()
        }
    }
    
    /// Content alignment.
    internal var contentAlignment: SegmentedItemContentAlignment = .center {
        
        didSet {
            
            guard self.contentAlignment != oldValue else { return }
            self.updateConstraintsActivity()
        }
    }
    
    //MARK: Methods
    
    internal override func prepareForReuse() {
        
        super.prepareForReuse()
        self.normalImage = nil
        self.selectedImage = nil
        self.transformableViewSize = .zero
        self.active = 0.0
        
        self.normalImageView?.isHidden = false
        self.selectedImageView?.isHidden = false
    }
    
    // MARK: - Fileprivate -
    // MARK: Constants
    
    fileprivate struct SegmentedItemCollectionViewCellConstants {
        
        fileprivate static let minimalScale: CGFloat = 0.7
        fileprivate static let maximalScale: CGFloat = 1.0
    }
    
    //MARK: - Private -
    //MARK: Properties
    
    @IBOutlet private weak var transformableView: UIView?
    
    @IBOutlet private weak var normalImageView: UIImageView?
    @IBOutlet private weak var selectedImageView: UIImageView?
    
    @IBOutlet private weak var transformableViewWidthConstraint: NSLayoutConstraint?
    @IBOutlet private weak var transformableViewHeightConstraint: NSLayoutConstraint?
    
    @IBOutlet private var transformableViewLeftOffsetConstraint: NSLayoutConstraint?
    @IBOutlet private var transformableViewRightOffsetConstraint: NSLayoutConstraint?
    @IBOutlet private var transformableViewTopOffsetConstraint: NSLayoutConstraint?
    @IBOutlet private var transformableViewBottomOffsetConstraint: NSLayoutConstraint?
    @IBOutlet private var transformableViewHorizontalCenterAlignmentConstraint: NSLayoutConstraint?
    @IBOutlet private var transformableViewVerticalCenterAlignmentConstraint: NSLayoutConstraint?
    
    private weak var customView: UIView?
    
    private var realActive: CGFloat {
        
        return tap_clamp(value: self.active, low: 0.0, high: 1.0)
    }
    
    private var allAlignmentConstraints: [NSLayoutConstraint] {
        
        var result: [NSLayoutConstraint] = []
        
        if let nonnullLeft = self.transformableViewLeftOffsetConstraint { result += nonnullLeft }
        if let nonnullRight = self.transformableViewRightOffsetConstraint { result += nonnullRight }
        if let nonnullTop = self.transformableViewTopOffsetConstraint { result += nonnullTop }
        if let nonnullBottom = self.transformableViewBottomOffsetConstraint { result += nonnullBottom }
        if let nonnullHorizontal = self.transformableViewHorizontalCenterAlignmentConstraint { result += nonnullHorizontal }
        if let nonnullVertical = self.transformableViewVerticalCenterAlignmentConstraint { result += nonnullVertical }
        
        return result
    }
    
    //MARK: Methods
    
    private func updateTransform() {
        
        let desiredScale = CGFloat.tap_interpolate(start: self.minimalTransformableScale, finish: self.maximalTransformableScale, progress: self.realActive)
        self.transformableView?.transform = CGAffineTransform(scaleX: desiredScale, y: desiredScale)
    }
    
    private func updateImagesAlpha() {
        
        if self.shouldUseOnlyNormalImage {
            
            self.normalImageView?.alpha = 1.0
            self.selectedImageView?.alpha = 0.0
        }
        else {
            
            let appliedActive = self.realActive
            
            self.normalImageView?.alpha = 1.0 - appliedActive
            self.selectedImageView?.alpha = appliedActive
        }
    }
    
    private func updateConstraintsActivity() {
        
        guard let nonnullLeft = self.transformableViewLeftOffsetConstraint else { return }
        guard let nonnullRight = self.transformableViewRightOffsetConstraint else { return }
        guard let nonnullTop = self.transformableViewTopOffsetConstraint else { return }
        guard let nonnullBottom = self.transformableViewBottomOffsetConstraint else { return }
        guard let nonnullHorizontal = self.transformableViewHorizontalCenterAlignmentConstraint else { return }
        guard let nonnullVertical = self.transformableViewVerticalCenterAlignmentConstraint else { return }
        
        var constraintsToActivate: [NSLayoutConstraint] = []
        
        switch self.contentAlignment {
            
        case .topLeft:
            
            constraintsToActivate.append(contentsOf:[nonnullLeft, nonnullTop])
            break
            
        case .top:
            
            constraintsToActivate.append(contentsOf:[nonnullTop, nonnullHorizontal])
            break
            
        case .topRight:
            
            constraintsToActivate.append(contentsOf:[nonnullTop, nonnullRight])
            break
            
        case .left:
            
            constraintsToActivate.append(contentsOf:[nonnullLeft, nonnullVertical])
            break
            
        case .center:
            
            constraintsToActivate.append(contentsOf:[nonnullHorizontal, nonnullVertical])
            break
            
        case .right:
            
            constraintsToActivate.append(contentsOf:[nonnullRight, nonnullVertical])
            break
            
        case .bottomLeft:
            
            constraintsToActivate.append(contentsOf:[nonnullBottom, nonnullLeft])
            break
            
        case .bottom:
            
            constraintsToActivate.append(contentsOf:[nonnullBottom, nonnullHorizontal])
            break
            
        case .bottomRight:
            
            constraintsToActivate.append(contentsOf:[nonnullBottom, nonnullRight])
            break
        }
        
        let constraintsToDeactivate = (self.allAlignmentConstraints - constraintsToActivate).filter { $0.isActive }
        constraintsToActivate = constraintsToActivate.filter { !$0.isActive }
        
        if constraintsToDeactivate.count > 0 {
            
            NSLayoutConstraint.deactivate(constraintsToDeactivate)
        }
        
        if constraintsToActivate.count > 0 {
            
            NSLayoutConstraint.activate(constraintsToActivate)
        }
    }
}

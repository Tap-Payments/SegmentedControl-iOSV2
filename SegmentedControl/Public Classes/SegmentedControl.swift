//
//  SegmentedControl.swift
//  SegmentedControl
//
//  Created by Dennis Pashkov on 5/23/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import CoreGraphics
import TapAdditionsKitV2
import class TapNibViewV2.TapNibView
import class UIKit.UIView.UIView
import enum UIKit.UIView.UISemanticContentAttribute

/// Custom Segmented Control.
@IBDesignable public class SegmentedControl: TapNibView {
    
    //MARK: - Public -
    //MARK: Properties
    
    /// Data source.
    public weak var dataSource: SegmentedControlDataSource?
    
    /// Delegate.
    @IBOutlet public weak var delegate: SegmentedControlDelegate?
    
    /// Items.
    public var items: [SegmentedItem] = [] {
        
        didSet {
            
            self.processor.reload()
        }
    }
    
    /// Selected segment.
    public var selectedSegment: CGFloat = 0.0 {
        
        didSet {
            
            let itemsCountMinusOne = CGFloat(self.items.count - 1)
            let segment = self.selectedSegment
            
            let appliedValue = tap_clamp(value: segment, low: 0.0, high: itemsCountMinusOne)
            
            if appliedValue != segment {
                
                self.selectedSegment = appliedValue
                return
            }
            
            self.processor.updateIndex()
        }
    }
    
    /// Minimal segment width.
    @IBInspectable public var minimalSegmentWidth: CGFloat = 50.0 {
        
        didSet {
            
            self.processor.reload()
        }
    }
    
    /// Maximal segment width.
    @IBInspectable public var maximalSegmentWidth: CGFloat = .greatestFiniteMagnitude {
        
        didSet {
            
            self.processor.reload()
        }
    }
    
    /// Defines if space between cells is increasing to fill the bounds of the segmented control ( only if content size less then segmented control size ).
    @IBInspectable public var spreadsSegmentsAcrossBounds: Bool = false {
        
        didSet {
            
            self.processor.reload()
        }
    }
    
    /// Stripe height.
    @IBInspectable public var stripeHeight: CGFloat {
        
        get {
            
            return self.processor.stripeHeight
        }
        set {
            
            self.processor.stripeHeight = newValue
        }
    }
    
    /// Minimal top distance to the stripe ( e.g. minimal distance between the stripe and the icon ).
    @IBInspectable public var minimalTopDistanceToStripe: CGFloat {
        
        get {
            
            return self.processor.minimalTopDistanceToStripe
        }
        set {
            
            self.processor.minimalTopDistanceToStripe = newValue
        }
    }
    
    /// Defines if magnification is enabled for selected segmented in comparance with unselected ones.
    @IBInspectable public var segmentsMagnificationEnabled: Bool = true {
        
        didSet {
            
            self.processor.reload()
        }
    }
    
    /// Defines if the receiver uses only LTR layout direction. This property has no effect on iOS 8 and lower.
    @IBInspectable public var forcesLeftToRightLayoutDirection: Bool = false {
        
        didSet {
            
            if #available(iOS 9.0, *) {
                
                self.tap_applySemanticContentAttribute(self.forcesLeftToRightLayoutDirection ? .forceLeftToRight : self.semanticContentAttribute)
            }
        }
    }
    
    public override class var requiresConstraintBasedLayout: Bool {
        
        return true
    }
    
    @available(iOS 9.0, *)
    public override var semanticContentAttribute: UISemanticContentAttribute {
        
        get {
            
            return self.forcesLeftToRightLayoutDirection ? .forceLeftToRight : super.semanticContentAttribute
        }
        set {
            
            let requiredDirection = self.forcesLeftToRightLayoutDirection ? .forceLeftToRight : newValue
            
            if super.semanticContentAttribute != requiredDirection {
                
                super.semanticContentAttribute = requiredDirection
            }
        }
    }
    
    //MARK: Methods
    
    public override func setup() {
        
        if #available(iOS 9.0, *) {
            
            self.tap_applySemanticContentAttribute(.forceLeftToRight)
        }
    }
    
    public override func layoutSubviews() {
        
        super.layoutSubviews()
        
        self.processor.updateIndex()
    }
    
    public override func updateConstraints() {
        
        self.processor.updateStripeViewConstraints()
        super.updateConstraints()
    }
    
    /// Returns the view that displays corresponding segment.
    ///
    /// - Parameter item: Segment.
    /// - Returns: View.
    public func segmentView(for item: SegmentedItem) -> UIView? {
        
        return self.processor.segmentView(for:item)
    }
    
    //MARK: - Private -
    //MARK: Properties
    
    @IBOutlet private var processor: SegmentedControlProcessor!
}

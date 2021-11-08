//
//  SegmentedItemSettings.swift
//  SegmentedControl
//
//  Created by Dennis Pashkov on 5/23/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import struct CoreGraphics.CGGeometry.CGSize
import class UIKit.UIColor.UIColor
import class UIKit.UIImage.UIImage

/// Segmented Item Settings.
public struct SegmentedItemSettings {

    //MARK: - Public -
    //MARK: Properties
    
    /// Item icon.
    public var icon: UIImage
    
    /// Icon size.
    public var iconSize: CGSize
    
    /// Stripe color.
    public var stripeColor: UIColor
    
    /// Creates settings with the icon and underline color.
    ///
    /// - Parameters:
    ///   - theIcon: Icon.
    ///   - sColor: Underline color.
    public init(icon theIcon: UIImage, stripeColor sColor: UIColor) {
        
        self.init(icon: theIcon, iconSize: theIcon.size, stripeColor: sColor)
    }
    
    /// Creates settings with the icon, its size and underline color.
    ///
    /// - Parameters:
    ///   - theIcon: Icon.
    ///   - iSize: Icon size.
    ///   - sColor: Underline color.
    public init(icon theIcon: UIImage, iconSize iSize: CGSize, stripeColor sColor: UIColor) {
        
        self.icon = theIcon
        self.iconSize = iSize
        self.stripeColor = sColor
    }
}

// MARK: - Equatable
extension SegmentedItemSettings: Equatable {
    
    public static func ==(lhs: SegmentedItemSettings, rhs: SegmentedItemSettings) -> Bool {
        
        return lhs.iconSize == rhs.iconSize && lhs.icon == rhs.icon && lhs.stripeColor == rhs.stripeColor
    }
}

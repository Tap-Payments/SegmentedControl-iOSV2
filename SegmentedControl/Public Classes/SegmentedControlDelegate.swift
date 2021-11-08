//
//  SegmentedControlDelegate.swift
//  SegmentedControl
//
//  Created by Dennis Pashkov on 5/24/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import CoreGraphics

@objc public protocol SegmentedControlDelegate: class {
    
    @objc optional func segmentedControl(_ segmentedControl: SegmentedControl, didSelectSegment segment: CGFloat)
}

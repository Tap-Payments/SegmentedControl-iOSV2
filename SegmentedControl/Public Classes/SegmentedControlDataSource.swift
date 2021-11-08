//
//  SegmentedControlDataSource.swift
//  SegmentedControl
//
//  Created by Dennis Pashkov on 8/28/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import class UIKit.UIView.UIView

/// Segmented Control Data Source.
public protocol SegmentedControlDataSource: class {
    
    func segmentedControl(_ segmentedControl: SegmentedControl, customViewFor item: SegmentedItem) -> UIView?
}

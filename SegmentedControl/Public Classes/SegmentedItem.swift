//
//  SegmentedItem.swift
//  SegmentedControl
//
//  Created by Dennis Pashkov on 5/23/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

/// Segmented item.
public class SegmentedItem {
    
    //MARK: - Public -
    //MARK: Properties
    
    /// Normal item settings.
    public var normalSettings: SegmentedItemSettings
    
    /// Selected item settings.
    public var selectedSettings: SegmentedItemSettings
    
    /// Content alignment.
    public var contentAlignment: SegmentedItemContentAlignment
    
    /// Defines if there is custom view for an item.
    public var hasCustomView: Bool
    
    //MARK: Methods
    
    /// Initializes new instance of SegmentedItem with the settings.
    ///
    /// - Parameters:
    ///   - nSettings: Normal settings.
    ///   - sSettings: Selected settings.
    public convenience init(normalSettings nSettings: SegmentedItemSettings, selectedSettings sSettings: SegmentedItemSettings) {
        
        self.init(normalSettings: nSettings, selectedSettings: sSettings, contentAlignment: .center, hasCustomView: false)
    }
    
    /// Initializes new instance of SegmentedItem with the settings.
    ///
    /// - Parameters:
    ///   - nSettings: Normal settings.
    ///   - sSettings: Selected settings.
    ///   - cAlignment: Content alignment.
    ///   - hasCView: Defines if there is a custom view for an item.
    public init(normalSettings nSettings: SegmentedItemSettings, selectedSettings sSettings: SegmentedItemSettings, contentAlignment cAlignment: SegmentedItemContentAlignment, hasCustomView hasCView: Bool) {
        
        self.normalSettings = nSettings
        self.selectedSettings = sSettings
        self.contentAlignment = cAlignment
        self.hasCustomView = hasCView
        self.hasSingleImageForBothStates = nSettings.icon == sSettings.icon
    }
    
    //MARK: - Internal -
    //MARK Properties
    
    internal private(set) var hasSingleImageForBothStates: Bool
}

// MARK: - Equatable
extension SegmentedItem: Equatable {
    
    public static func ==(lhs: SegmentedItem, rhs: SegmentedItem) -> Bool {
        
        return lhs.normalSettings == rhs.normalSettings && lhs.selectedSettings == rhs.selectedSettings && lhs.contentAlignment == rhs.contentAlignment && lhs.hasCustomView == rhs.hasCustomView
    }
}

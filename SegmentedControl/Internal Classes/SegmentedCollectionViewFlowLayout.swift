//
//  SegmentedCollectionViewFlowLayout.swift
//  SegmentedControl
//
//  Created by Dennis Pashkov on 5/23/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import struct CoreGraphics.CGGeometry.CGRect
import class UIKit.UICollectionViewFlowLayout.UICollectionViewFlowLayout
import class UIKit.UICollectionViewLayout.UICollectionViewLayoutAttributes

internal class SegmentedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    //MARK: - Internal -
    //MARK: Methods
    
    internal override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        return self.layoutAttributesForItem(at:itemIndexPath)
    }
    
    internal override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        return self.layoutAttributesForItem(at:itemIndexPath)
    }
    
    internal override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        var resultingAttributes: [UICollectionViewLayoutAttributes] = []
        for attribute in attributes {
            
            if rect.intersects(attribute.frame) {
                
                resultingAttributes.append(attribute)
            }
        }
        
        return resultingAttributes
    }
    
    internal override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        return false
    }
    
    internal override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        guard let attributes = super.layoutAttributesForItem(at: indexPath) else { return nil }
        
        attributes.alpha = 1.0
        
        return attributes
    }
}

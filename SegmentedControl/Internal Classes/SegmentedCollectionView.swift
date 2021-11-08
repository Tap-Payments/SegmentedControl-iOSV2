//
//  SegmentedCollectionView.swift
//  SegmentedControl
//
//  Created by Dennis Pashkov on 8/29/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import struct CoreGraphics.CGGeometry.CGRect
import class UIKit.UICollectionView.UICollectionView

/// Segmented Collection View.
internal class SegmentedCollectionView: UICollectionView {
    
    //MARK: - Internal -
    //MARK: Properties
    
    internal override var bounds: CGRect {
        
        didSet {
            
            if let segmentedDelegate = self.delegate as? SegmentedCollectionViewDelegate {
                
                segmentedDelegate.collectionViewBoundsChanged(self)
            }
        }
    }
}

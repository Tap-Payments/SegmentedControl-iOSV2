//
//  SegmentedCollectionViewDelegate.swift
//  SegmentedControl
//
//  Created by Dennis Pashkov on 8/29/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import protocol UIKit.UICollectionViewFlowLayout.UICollectionViewDelegateFlowLayout

/// Segmented Collection View Delegate.
internal protocol SegmentedCollectionViewDelegate: UICollectionViewDelegateFlowLayout {
    
    /// Notifies delegate that bounds have changed.
    ///
    /// - Parameter collectionView: Sender.
    func collectionViewBoundsChanged(_ collectionView: SegmentedCollectionView)
}

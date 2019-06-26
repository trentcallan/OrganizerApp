//
//  GoalsFlowLayout.swift
//  College
//
//  Created by Trent Callan on 6/12/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import UIKit

class GoalsFlowLayout: UICollectionViewFlowLayout {
    
    var delegate: GoalsLayoutDelegate!
    var cache = [UICollectionViewLayoutAttributes]()
    var headerCache = [UICollectionViewLayoutAttributes]()

    var headerHeight: CGFloat = 96
    
    var numberOfColumns = 2
    var cellPadding: CGFloat = 8
    var contentHeight: CGFloat = 0
    var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
        
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
        
    override func prepare() {
        
        guard /*cache.isEmpty == true,*/ let collectionView = collectionView else {
            return
        }
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        if(!headerCache.isEmpty) {
            headerCache.removeAll()
        }
        
        for section in 0...collectionView.numberOfSections-1 {
            
            let headerIndexPath = IndexPath(item: 0, section: section)
            let headerCellAttributes =
                UICollectionViewLayoutAttributes(
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    with: headerIndexPath)
            // y is the biggest y value from last section
            let y = yOffset[0] > yOffset[1] ? yOffset[0] : yOffset[1]
            headerCellAttributes.frame = CGRect(x: cellPadding, y: y, width: self.contentWidth-2*cellPadding, height: self.headerHeight)
            headerCache.append(headerCellAttributes)
            
            // Set the yOffsets to the right amount after adding a header
            if(yOffset[0] > yOffset[1]) {
                yOffset[0] = yOffset[0] + self.headerHeight
                yOffset[1] = yOffset[0]
            } else {
                yOffset[1] = yOffset[1] + self.headerHeight
                yOffset[0] = yOffset[1]
            }

            column = 0
            
            for item in 0 ..< collectionView.numberOfItems(inSection: section) {
                
                let indexPath = IndexPath(item: item, section: section)
                let size = CGSize(width: columnWidth, height: 800)
                // Get the text of goal title and goal description
                let goalDesc = delegate.collectionView(collectionView, goalDesc: indexPath)
                let goalTitle = delegate.collectionView(collectionView, goalTitle: indexPath)
                // Get the estimated height when you know width and font size
                let estimatedHeightOfGoalDescription = NSString(string: goalDesc).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: 17)], context: nil)
                let estimatedHeightOfGoalTitle = NSString(string: goalTitle).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: 17)], context: nil)
                // Set the height of the cell
                let height = cellPadding * 2 + estimatedHeightOfGoalDescription.height + estimatedHeightOfGoalTitle.height + 200 + 2

                // If last item in a section doesnt have an entry in the other column
                // And the other column is lower than the column it's supposed to go in
                // Then move it to the other column
                if(item+1 == collectionView.numberOfItems(inSection: section) && (item+1) % 2 == 1 && yOffset[1] < yOffset[0]) {
                    column = column < (numberOfColumns - 1) ? (column + 1) : 0
                }
                
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                cache.append(attributes)
                
                contentHeight = max(contentHeight, frame.maxY)
                yOffset[column] = yOffset[column] + height
                
                column = column < (numberOfColumns - 1) ? (column + 1) : 0
            }
        }

    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        let sectionsToAdd = NSMutableIndexSet()
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
                // Find what sections to add
                sectionsToAdd.add(attributes.indexPath.section)
            }
        }
        
        // For each section add layout attributes for the section header
        for section in sectionsToAdd {
            let indexPath = IndexPath(item: 0, section: section)

            if let sectionAttributes = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath) {
                visibleLayoutAttributes.append(sectionAttributes)
            }
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }

/****************************************************************************************************/
    // For the header
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return headerCache[indexPath.section]
    }
    
/****************************************************************************************************/
    // For inserting animations
    var insertingIndexPaths = [IndexPath]()
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        
        insertingIndexPaths.removeAll()
        
        for update in updateItems {
            if let indexPath = update.indexPathAfterUpdate,
                update.updateAction == .insert {
                insertingIndexPaths.append(indexPath)
            }
        }
    }
    
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        
        insertingIndexPaths.removeAll()
    }
    
    override func initialLayoutAttributesForAppearingItem(
        at itemIndexPath: IndexPath
        ) -> UICollectionViewLayoutAttributes? {
        let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        
        if insertingIndexPaths.contains(itemIndexPath) {
            attributes?.alpha = 0.0
            attributes?.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1).translatedBy(x: 100, y: 100)
        }
        
        return attributes
    }
/****************************************************************************************************/
    
}

protocol GoalsLayoutDelegate {
    func collectionView(_ collectionView:UICollectionView, goalTitle indexPath:IndexPath) -> String
    func collectionView(_ collectionView:UICollectionView, goalDesc indexPath:IndexPath) -> String
}

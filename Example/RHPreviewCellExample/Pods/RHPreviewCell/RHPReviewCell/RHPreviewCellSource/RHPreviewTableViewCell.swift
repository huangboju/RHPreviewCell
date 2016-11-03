//
//  RHPreviewTableViewCell.swift
//  RHPreviewCell
//
//  Created by Robert Herdzik on 25/09/2016.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit

open class RHPreviewTableViewCell: UITableViewCell {
    fileprivate var tilesManagerView: RHPreviewTilesContainerView!
    
    open weak var delegate: RHPreviewCellDelegate?
    open weak var dataSource: RHPreviewCellDataSource?
    
    var pressDuration = CFTimeInterval(0.4)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addGesture()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func fulfilTilesContent() {
        guard let numberOfTiles = dataSource?.previewCellNumberOfTiles(self) else {
            assertionFailure("previewCellNumberOfTiles not implemented 😥")
            return
        }
        
        var newTiles = [RHPreviewTileView]()
        for index in 0...numberOfTiles - 1 {
            if let tile = dataSource?.previewCell(self, tileForIndex: index) {
                newTiles.append(tile)
            }
        }
        
        tilesManagerView.reloadTiles(withNew: newTiles)
    }
    
    fileprivate func addGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(triggerLongPress))
        longPressGesture.minimumPressDuration = pressDuration
        
        contentView.addGestureRecognizer(longPressGesture)
    }
    
    fileprivate func creteTilesPresenterIfNecessary() {
        if tilesManagerView != nil { return }
        
        tilesManagerView = RHPreviewTilesContainerView(frame: bounds)
        tilesManagerView.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        contentView.addSubview(tilesManagerView!)
        
        fulfilTilesContent()
    }
    
    fileprivate func showTiles(_ completion: @escaping RHTilesAnimationComplitionBlock) {
        tilesManagerView.isHidden = false
        tilesManagerView.showElements(completion)
    }
    
    fileprivate func hideTiles() {
        tilesManagerView.hideElements { [weak self] in self?.tilesManagerView.isHidden = true }
    }
    
    fileprivate func passFingerPositionToPresenter(from recognizer: UILongPressGestureRecognizer) {
        let fingerPosition = recognizer.location(in: contentView)
        tilesManagerView.gestureOffset(fingerPosition)
    }
    
    fileprivate func getSelectedTileIndexValue() -> RHTappedTileIndexValue {
        if tilesManagerView.selectedTileIndex < 0 {
            return RHTappedTileIndexValue.fingerReleased
        } else {
            return RHTappedTileIndexValue.tileTapped(tilesManagerView.selectedTileIndex)
        }
    }
    
    func triggerLongPress(_ recognizer: UILongPressGestureRecognizer) {
        creteTilesPresenterIfNecessary()
        
        switch recognizer.state {
        case .began:
            showTiles { [weak self] in self?.passFingerPositionToPresenter(from: recognizer) }
        case .changed:
            passFingerPositionToPresenter(from: recognizer)
        case .cancelled, .ended, .failed:
            
            delegate?.previewCell(self, didSelectTileAtIndex: getSelectedTileIndexValue())
            hideTiles()
            
        default:
            print("default")
        }
    }
}

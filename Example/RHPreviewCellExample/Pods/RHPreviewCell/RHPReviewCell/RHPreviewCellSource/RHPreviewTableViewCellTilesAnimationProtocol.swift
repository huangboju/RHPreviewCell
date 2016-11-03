//
//  RHPreviewTableViewCellTilesAnimationProtocol.swift
//  RHPreviewCell
//
//  Created by Robert Herdzik on 25/09/2016.
//  Copyright © 2016 Robert. All rights reserved.
//

protocol RHPreviewTableViewCellTilesAnimationProtocol {
    func performShowAnimation(tiles: [RHPreviewTileView], completion: @escaping RHTilesAnimationComplitionBlock)
    func performHideAnimation(tiles: [RHPreviewTileView], completion: @escaping RHTilesAnimationComplitionBlock)
    func performMagnifyAnimation(tile: RHPreviewTileView)
}

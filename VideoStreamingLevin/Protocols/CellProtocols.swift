//
//  CellProtocols.swift
//  VideoStreamingLevin
//
//  Created by Levin varghese on 24/11/19.
//  Copyright © 2019 Levin Varghese. All rights reserved.
//

import Foundation
import UIKit

protocol ConfigurableCell {
    associatedtype DataType
    func configure(data: DataType)
}

protocol CellConfigurator {
    var reuseId: String { get }
    func configure(cell: UIView)
    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell
}

protocol CellConfiguratorCollection {
    var reuseId: String { get }
    func configure(cell: UIView)
    func cellForCollectionView(collectionView: UICollectionView,  atIndexPath indexPath: IndexPath) -> UICollectionViewCell
}



class TableCellConfigurator<CellType: ConfigurableCell, DataType>: CellConfigurator where CellType.DataType == DataType, CellType: UITableViewCell {
    
    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        self.configure(cell: cell)
        return cell
    }
    
    var reuseId: String { return String(describing: CellType.self) }
    
    let item: DataType
    
    init(item: DataType) {
        self.item = item
    }
    
    func configure(cell: UIView) {
        (cell as! CellType).configure(data: item)
    }
}

class CollectionCellConfigurator<CellType: ConfigurableCell, DataType>: CellConfiguratorCollection where CellType.DataType == DataType, CellType: UICollectionViewCell {
    
    func cellForCollectionView(collectionView: UICollectionView,  atIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath)
        self.configure(cell: cell)
        return cell
    }
    
    var reuseId: String { return String(describing: CellType.self) }
    
    let item: DataType
    
    init(item: DataType) {
        self.item = item
    }
    
    func configure(cell: UIView) {
        (cell as! CellType).configure(data: item)
    }
}

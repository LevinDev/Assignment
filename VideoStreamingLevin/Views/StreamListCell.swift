//
//  StreamListCell.swift
//  VideoStreamingLevin
//
//  Created by Levin Varghese on 11/24/19.
//  Copyright © 2019 Levin Varghese. All rights reserved.
//

import UIKit

class StreamListCell: UITableViewCell,ConfigurableCell {
 
    @IBOutlet weak var ImageViewThumbnail: UIImageView?
    @IBOutlet weak var labelName: UILabel?
    
   
    
    func configure(data: Stream) {
        guard  data.thumbnail == .none else {
            self.ImageViewThumbnail?.image = data.thumbnail
            return
        }
        labelName?.text = data.url
        data.getThumbnail { [weak self] (image) in
            self?.ImageViewThumbnail?.image = image
        }
    }

}

class StreamCollectionCell: UICollectionViewCell,ConfigurableCell {
    
   @IBOutlet weak var ImageViewThumbnail: UIImageView?
   var thumbnailGenerator: StreamThumbnailGenerator?
    
    func configure(data: Stream) {
        data.getThumbnail { [weak self] (image) in
            self?.ImageViewThumbnail?.image = image
        }
        
    }

    
}

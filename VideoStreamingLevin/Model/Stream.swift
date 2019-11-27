//
//  Stream.swift
//  VideoStreamingLevin
//
//  Created by Levin varghese on 24/11/19.
//  Copyright © 2019 Levin Varghese. All rights reserved.
//

import Foundation
import UIKit

typealias StreamCellConfigurator = TableCellConfigurator<StreamListCell, Stream>
typealias StreamCellCollectionConfigurator = CollectionCellConfigurator<StreamCollectionCell, Stream>

class Stream {
    var url: String
    var thumbnail: UIImage?
    var description: String
    var thumbnailGenerator: StreamThumbnailGenerator?
    
    init(url: String, description: String) {
        self.url = url
        self.description = description
    }
}

extension Stream {
    func getThumbnail(completion: @escaping (_ image: UIImage) -> Void) {
        if let thumb = self.thumbnail {
            completion(thumb)
        }
        thumbnailGenerator = StreamThumbnailGenerator(streamUrl: URL(string: self.url)! )
        thumbnailGenerator?.captureImage(at: 300, completion: { [weak self] (Image) in
            self?.thumbnail = Image
            completion(Image)
        })
    }
    
    func convert() -> StreamCellCollectionConfigurator {
       return StreamCellCollectionConfigurator(item: self)
    }
}

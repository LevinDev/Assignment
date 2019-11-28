//
//  AVPlayer+Helper.swift
//  VideoStreamingLevin
//
//  Created by Levin varghese on 28/11/19.
//  Copyright © 2019 Levin Varghese. All rights reserved.
//

import Foundation
import AVKit

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}

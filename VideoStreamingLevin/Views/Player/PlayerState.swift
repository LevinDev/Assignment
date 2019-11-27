//
//  PlayerState.swift
//  VideoStreamingLevin
//
//  Created by Levin Varghese on 11/25/19.
//  Copyright © 2019 Levin Varghese. All rights reserved.
//

import Foundation

enum PlayerState {
    case readyToPlay
    case failed
    case playbackEndend
}

enum PlayerAction {
    case play
    case pause
    case expand
}

//
//  VideoFullscreenPlayerView
//  VideoStreamingLevin
//
//  Created by Levin varghese on 24/11/19.
//  Copyright © 2019 Levin Varghese. All rights reserved.
//

import UIKit

public class VideoFullscreenPlayerView: UIView {

    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if let animation = layer.animation(forKey: "bounds.size") {
            CATransaction.begin()
            CATransaction.setAnimationDuration(animation.duration)
            CATransaction.setAnimationTimingFunction(animation.timingFunction)
            layer.sublayers?.forEach({ $0.frame = bounds })
            CATransaction.commit()
        } else {
            layer.sublayers?.forEach({ $0.frame = bounds })
        }
    }

}

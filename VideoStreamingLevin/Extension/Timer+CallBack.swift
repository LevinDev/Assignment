//
//  Timer+CallBack.swift
//  VideoStreamingLevin
//
//  Created by Levin varghese on 28/11/19.
//  Copyright © 2019 Levin Varghese. All rights reserved.
//

import Foundation

extension Timer {
    
    // MARK: Schedule timers
    
    @discardableResult
    public class func after(_ interval: TimeInterval, _ block: @escaping () -> Void) -> Timer {
        let timer = Timer.new(after: interval, block)
        timer.start()
        return timer
    }
    
    @discardableResult
    public class func every(_ interval: TimeInterval, _ block: @escaping () -> Void) -> Timer {
        let timer = Timer.new(every: interval, block)
        timer.start()
        return timer
    }
    
    
    @nonobjc @discardableResult
    public class func every(_ interval: TimeInterval, _ block: @escaping (Timer) -> Void) -> Timer {
        let timer = Timer.new(every: interval, block)
        timer.start()
        return timer
    }
    
    public class func new(after interval: TimeInterval, _ block: @escaping () -> Void) -> Timer {
        return CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + interval, 0, 0, 0) { _ in
            block()
        }
    }
    
    public class func new(every interval: TimeInterval, _ block: @escaping () -> Void) -> Timer {
        return CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + interval, interval, 0, 0) { _ in
            block()
        }
    }
    
    
    @nonobjc public class func new(every interval: TimeInterval, _ block: @escaping (Timer) -> Void) -> Timer {
        var timer: Timer!
        timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + interval, interval, 0, 0) { _ in
            block(timer)
        }
        return timer
    }
    
    
    public func start(runLoop: RunLoop = .current, modes: RunLoop.Mode...) {
        let modes = modes.isEmpty ? [.default] : modes
        
        for mode in modes {
            runLoop.add(self, forMode: mode)
        }
    }
}

// MARK: - Time extensions
extension Double {
    public var millisecond: TimeInterval  { return self / 1000 }
    public var milliseconds: TimeInterval { return self / 1000 }
    public var ms: TimeInterval           { return self / 1000 }
    
    public var second: TimeInterval       { return self }
    public var seconds: TimeInterval      { return self }
    
    public var minute: TimeInterval       { return self * 60 }
    public var minutes: TimeInterval      { return self * 60 }
    
    public var hour: TimeInterval         { return self * 3600 }
    public var hours: TimeInterval        { return self * 3600 }
    
    public var day: TimeInterval          { return self * 3600 * 24 }
    public var days: TimeInterval         { return self * 3600 * 24 }
}

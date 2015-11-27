//
//  Timer.swift
//  VKUniMTSample
//
//  Created by Dmitry Zakharov on 26/11/15.
//  Copyright © 2015 VKontakte. All rights reserved.
//

import Darwin
import Foundation

public struct Timer {
    private static var base: UInt64 = 0
    
    private var startTime: UInt64 = 0
    private var stopTime: UInt64 = 0
    
    init() {
        if self.dynamicType.base == 0 {
            var info = mach_timebase_info(numer: 0, denom: 0)
            mach_timebase_info(&info)
            self.dynamicType.base = UInt64(info.numer / info.denom)
        }
    }
    
    public mutating func start() {
        startTime = mach_absolute_time()
    }
    
    public mutating func stop() {
        stopTime = mach_absolute_time()
    }
    
    public var nanoseconds: UInt64 {
        return (stopTime - startTime) * Timer.base
    }
    
    public var milliseconds: Double {
        return Double(nanoseconds) / 1_000_000
    }
    
    public var seconds: Double {
        return Double(nanoseconds) / 1_000_000_000
    }
    
    public static func executeWithTimer(block: dispatch_block_t) -> Double {
        var timer = self.init()
        timer.start()
        
        block()
        
        timer.stop()
        
        return timer.seconds
    }
}

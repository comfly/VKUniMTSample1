//
//  PrimeNumberProducer.swift
//  VKUniMTSample
//
//  Created by Dmitry Zakharov on 27/11/15.
//  Copyright © 2015 VKontakte. All rights reserved.
//

import Foundation

public class PrimeNumberProducer: NSThread {
    private let pause: Int
    private weak var queue: PCQueue?
    private let lock: NSCondition
    
    init(queue: PCQueue, pause: Int, lock: NSCondition) {
        self.queue = queue
        self.pause = pause
        self.lock = lock
    }
    
    private var lastPrime = 0
    override public func main() {
        while !cancelled {
            withCondition {
                lastPrime = nextPrimeStartingFrom(lastPrime)
                queue?.enqueue(lastPrime)
            }
            self.dynamicType.sleepForTimeInterval(NSTimeInterval(pause))
        }
    }
 
    var nextCount = 0
    private func withCondition(@noescape block: () throws -> Void) rethrows {
        defer { lock.unlock() }

        nextCount++
        
        lock.lock()
        for _ in 0..<nextCount {
            try block()
        }
        lock.broadcast()
    }
    
    private func nextPrimeStartingFrom(base: Int) -> Int {
        if base < 3 {
            return base + 1
        }
        
        // Same as { Int(ceil(sqrt(Double($0)))) }
        let upperBound: Int -> Int = (Int.init • ceil • sqrt • Double.init)
        
        var nextPrime = base + 2
        outer: while true {
            for d in 2...upperBound(nextPrime) {
                if nextPrime % d == 0 {
                    nextPrime += 2
                    continue outer
                }
            }
            return nextPrime
        }
     }
}
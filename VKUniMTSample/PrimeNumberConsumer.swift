//
//  PrimeNumberConsumer.swift
//  VKUniMTSample
//
//  Created by Dmitry Zakharov on 27/11/15.
//  Copyright © 2015 VKontakte. All rights reserved.
//

import Foundation

public class PrimeNumberConsumer: NSThread {
    typealias ConsumerBlock = [Int] -> Void
    
    private weak var queue: PCQueue?
    private var lock: NSCondition
    private let block: ConsumerBlock
    
    init(queue: PCQueue, lock: NSCondition, block: ConsumerBlock) {
        self.queue = queue
        self.lock = lock
        self.block = block
    }
    
    public override func main() {
        while !cancelled {
            withCondition(block)
        }
    }
    
    private func withCondition(block: ConsumerBlock) {
        defer { lock.unlock() }
        lock.lock()
        while let q = queue where q.isEmpty {
            lock.waitUntilDate(NSDate(timeIntervalSinceNow: NSTimeInterval(1)))
        }
        guard let queue = queue else { return }
        
        var primes = [Int]()
        while let prime = queue.dequeue() {
            primes.append(prime)
        }
        
        block(primes)
    }
}
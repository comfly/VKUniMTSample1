//
//  PCQueue.swift
//  VKUniMTSample
//
//  Created by Dmitry Zakharov on 27/11/15.
//  Copyright © 2015 VKontakte. All rights reserved.
//

import Foundation

public class PCQueue {
    private var queue = [Int]()
    
    public var isEmpty: Bool {
        return queue.count == 0
    }

    public func enqueue(element: Int) {
        queue.append(element)
    }
    
    public func dequeue() -> Int? {
        return isEmpty ? nil : queue.removeFirst()
    }
    
    public func drop() {
        queue.removeAll()
    }
}
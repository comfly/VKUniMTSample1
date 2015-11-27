//
//  ThreadSafeArray.swift
//  VKUniMTSample
//
//  Created by Dmitry Zakharov on 26/11/15.
//  Copyright © 2015 VKontakte. All rights reserved.
//

import Foundation


public class ThreadSafeArray<TElement>: ThreadSafeArrayProtocol {
    private var array = [TElement]()
    private let queue = dispatch_queue_create("ru.VKUniversity.ThreadSafeArrayQueue", DISPATCH_QUEUE_CONCURRENT)
    
    public subscript(index: Int) -> TElement {
        get {
            var result: TElement? = nil
            dispatch_sync(queue) {
                result = self.array[index]
            }
            return result!
        }
        set {
            dispatch_barrier_async(queue) {
                self.array[index] = newValue
            }
        }
    }
    
    public func append(item: TElement) {
        dispatch_barrier_async(queue) {
            self.array.append(item)
        }
    }
    
    public var count: Int {
        var result: Int = 0
        dispatch_sync(queue) {
            result = self.array.count
        }
        return result
    }
    
    public var extract: [TElement] {
        var result: [TElement]? = nil
        dispatch_sync(queue) {
            result = self.array
        }
        return result!
    }
    
    public func behead() -> TElement? {
        var result: TElement?
        dispatch_barrier_sync(queue) {
            result = self.array.removeFirst()
        }
        return result
    }
}

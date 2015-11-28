//
//  SerialArray.swift
//  VKUniMTSample
//
//  Created by Dmitry Zakharov on 28/11/15.
//  Copyright © 2015 VKontakte. All rights reserved.
//

import Foundation

public class SerialArray<TElement>: ThreadSafeArrayProtocol {
    private var array = [TElement]()
    private let queue = dispatch_queue_create("ru.VKUniversity.SerialArrayQueue", DISPATCH_QUEUE_SERIAL)
    
    public subscript(index: Int) -> TElement {
        get {
            var result: TElement? = nil
            dispatch_sync(queue) {
                result = self.array[index]
            }
            return result!
        }
        set {
            dispatch_async(queue) {
                self.array[index] = newValue
            }
        }
    }
    
    public func append(item: TElement) {
        dispatch_async(queue) {
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
}

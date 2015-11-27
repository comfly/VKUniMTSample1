//
//  SpinLockArray.swift
//  VKUniMTSample
//
//  Created by Dmitry Zakharov on 26/11/15.
//  Copyright © 2015 VKontakte. All rights reserved.
//

import Foundation
import libkern


public class SpinLockArray<TElement>: ThreadSafeArrayProtocol {
    private var array = [TElement]()
    private var lock = OS_SPINLOCK_INIT
    
    public subscript(index: Int) -> TElement {
        get {
            var result: TElement! = nil
            withLock {
                result = self.array[index]
            }
            return result
        }
        set {
            withLock {
                self.array[index] = newValue
            }
        }
    }
    
    public func withLock(@noescape f: () -> Void) {
        withUnsafeMutablePointer(&lock) { lock in
            OSSpinLockLock(lock)
            defer { OSSpinLockUnlock(lock) }
            f()
        }
    }
    
    public func append(item: TElement) {
        withLock {
            self.array.append(item)
        }
    }
    
    public var count: Int {
        var result: Int = 0
        withLock {
            result = self.array.count
        }
        return result
    }
    
    public var extract: [TElement] {
        var result: [TElement]! = nil
        withLock {
            result = self.array
        }
        return result
    }
}

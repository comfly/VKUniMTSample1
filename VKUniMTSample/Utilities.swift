//
//  Utilities.swift
//  VKUniMTSample
//
//  Created by Dmitry Zakharov on 26/11/15.
//  Copyright © 2015 VKontakte. All rights reserved.
//

import Foundation

public func nextRandom(maxValue: Int) -> Int {
    return Int(arc4random_uniform(UInt32(maxValue))) + 1
}

public let asyncOnMain = curry(dispatch_async)(dispatch_get_main_queue())

public let asyncOnDefault = curry(dispatch_async)(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0))

public func curry<A, B, R>(f: (A, B) throws -> R) rethrows -> A -> B -> R {
    return { a in { b in try! f(a, b) } }
}

public func curry<A, R>(f: A throws -> R) rethrows -> A -> R {
    return { a in try! f(a) }
}

public let DefaultNumberFormatter: NSNumberFormatter = {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .DecimalStyle
    formatter.roundingMode = .RoundHalfEven
    formatter.maximumFractionDigits = 2
    return formatter
}()

public let PreciseNumberFormatter: NSNumberFormatter = {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .DecimalStyle
    formatter.maximumFractionDigits = 4
    return formatter
}()

public let DefaultPercentFormatter: NSNumberFormatter = {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .PercentStyle
    formatter.roundingMode = .RoundHalfEven
    formatter.maximumFractionDigits = 1
    return formatter
}()

public func generateRandomNumbers(count: Int) -> [Int] {
    var result = [Int](count: count, repeatedValue: 0)
    for var index = 0; index < count; ++index {
        result[index] = nextRandom(count)
    }
    
    return result
}

infix operator • {
    associativity right
    precedence 200
}

public func •<A, B, R> (f: B -> R, g: A -> B) -> A -> R {
    return { a in f(g(a)) }
}

public func id<T>(x: T) -> T {
    return x
}

public func const<T, X>(value: T) -> (X -> T) {
    return { _ in value }
}

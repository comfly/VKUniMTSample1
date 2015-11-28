//
//  ImageLoadingSampleErrors.swift
//  VKUniMTSample
//
//  Created by Dmitry Zakharov on 27/11/15.
//  Copyright © 2015 VKontakte. All rights reserved.
//

import Foundation

public enum Result<T> {
    case Error(NSError)
    case Value(T)
    
    public func either<R>(l: NSError -> R, _ r: T -> R) -> R {
        switch self {
        case .Error(let e): return l(e)
        case .Value(let v): return r(v)
        }
    }
    
    public var asOptional: T? {
        return either(const(nil), id)
    }
}

public let ApplicationDomain = "ru.VKUniversity.ApplicationErrorDomain"
public enum Errors: Int {
    case ImageDataCorrupted = 1001,
         ImageNotLoaded,
         QueueIsEmpty,
         FileReadError
}


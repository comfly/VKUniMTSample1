//
//  ThreadSafeArrayProtocol.swift
//  VKUniMTSample
//
//  Created by Dmitry Zakharov on 26/11/15.
//  Copyright © 2015 VKontakte. All rights reserved.
//

import Foundation

protocol ThreadSafeArrayProtocol {
    typealias TElement
    subscript(index: Int) -> TElement { get set }
    func append(item: TElement)
    var count: Int { get }
    var extract: [TElement] { get }
}
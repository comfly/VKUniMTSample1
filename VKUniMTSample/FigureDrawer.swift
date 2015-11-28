//
//  FigureDrawer.swift
//  VKUniMTSample
//
//  Created by Dmitry Zakharov on 29/11/15.
//  Copyright © 2015 VKontakte. All rights reserved.
//

import UIKit
import PromiseKit


public struct FigureDrawer {
    public let side: CGFloat
    public var size: CGSize {
        return CGSizeMake(side, side)
    }
    
    public func draw(corners: Int) -> Promise<UIImage> {
        let side = self.side
        let size = self.size
        return Promise{ fulfill, reject in
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.mainScreen().scale)
                defer { UIGraphicsEndImageContext() }
                
                UIColor.blackColor().setStroke()
                UIColor.whiteColor().setFill()
                UIRectFill(CGRectMake(0, 0, side, side))
                
                drawFigure(corners, side)
                fulfill(UIGraphicsGetImageFromCurrentImageContext())
            }
        }
    }
}

private func drawFigure(corners: Int, _ side: CGFloat) {
    let angle = 2 * M_PI / Double(corners)
    let radius = (side - 2) / 2
    
    let center = side / 2
    
    let path = UIBezierPath()
    path.moveToPoint(CGPoint(x: side - 2, y: center))
    for corner in 1..<corners {
        let nextAngle = angle * Double(corner)
        let x = cos(nextAngle) * Double(radius) + Double(center)
        let y = sin(nextAngle) * Double(radius) + Double(center)
        let lineToPoint = CGPoint(x: x, y: y)
        path.addLineToPoint(lineToPoint)
    }
    path.closePath()
    path.stroke()
}

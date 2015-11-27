//
//  ImageLoadingOperation.swift
//  VKUniMTSample
//
//  Created by Dmitry Zakharov on 27/11/15.
//  Copyright © 2015 VKontakte. All rights reserved.
//

import UIKit

public class ImageLoadingOperation: NSOperation {
    private let category: String
    private let size: CGSize
    private let index: Int
    
    private(set) var result: Result<UIImage>
    
    init(category: String, size: CGSize, index: Int) {
        self.category = category
        self.size = size
        self.index = index
        
        result = .Error(NSError(domain: ApplicationDomain, code: Errors.ImageNotLoaded.rawValue, userInfo: nil))
    }
    
    override public func main() {
        do {
            let data = try NSData(contentsOfURL: buildImageURL(), options: .DataReadingMappedIfSafe)
            result = resultingImageFromData(data)
        } catch {
            result = .Error(error as NSError)
        }
    }
    
    private func resultingImageFromData(data: NSData) -> Result<UIImage> {
        if let image = UIImage(data: data) {
            return .Value(image)
        } else {
            return .Error(NSError(domain: ApplicationDomain, code: Errors.ImageDataCorrupted.rawValue, userInfo: nil))
        }
    }
    
    private func buildImageURL() -> NSURL {
        return NSURL(string: "http://lorempixel.com/\(Int(size.width))/\(Int(size.height))/\(category)/\(index)")!
    }
}

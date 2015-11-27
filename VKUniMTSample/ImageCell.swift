//
//  ImageCell.swift
//  VKUniMTSample
//
//  Created by Dmitry Zakharov on 27/11/15.
//  Copyright © 2015 VKontakte. All rights reserved.
//

import UIKit

internal class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    internal var image: UIImage? {
        didSet {
            self.imageView.image = self.image
        }
    }
}

//
//  PromiseSampleViewController.swift
//  VKUniMTSample
//
//  Created by Dmitry Zakharov on 29/11/15.
//  Copyright © 2015 VKontakte. All rights reserved.
//

import UIKit
import PromiseKit

class PromiseSampleViewController: BaseSampleViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var imagesView: UICollectionView!

    private let figureDrawer = FigureDrawer(side: 100)
    private var images = [Promise<UIImage>]()
    
    override class var sampleDescriptor: SampleDescriptor! {
        return SampleDescriptor(title: "\'Promises\' sample", storyboardID: "PromiseSampleViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("addFigureTapped"))
    }
    
    internal func addFigureTapped() {
        let promise = figureDrawer.draw(nextRandom(10) + 2)
        images.append(promise)
        promise.then(on: dispatch_get_main_queue()) {
            [weak self] _ in
            self?.insert()
        }
    }

    private func insert() {
        imagesView.insertItemsAtIndexPaths([NSIndexPath(forItem: images.count - 1, inSection: 0)])
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCellID", forIndexPath: indexPath) as! ImageCell
        cell.image = images[indexPath.row].value ?? nil
        return cell
    }
}

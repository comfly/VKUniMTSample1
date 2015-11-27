//
//  NSOperationQueueSampleViewController.swift
//  VKUniMTSample
//
//  Created by Dmitry Zakharov on 27/11/15.
//  Copyright © 2015 VKontakte. All rights reserved.
//

import UIKit

internal class NSOperationQueueSampleViewController: BaseSampleViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var imagesView: UICollectionView!
    
    private var images = ThreadSafeArray<UIImage>()
    private lazy var imagesLoadingQueue: NSOperationQueue = {
        let result = NSOperationQueue()
        result.maxConcurrentOperationCount = 1
        return result
    }()
    
    override class var sampleDescriptor: SampleDescriptor! {
        return SampleDescriptor(title: "\'Operation Queue\' sample", storyboardID: "NSOperationQueueSampleViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("loadNextImage"))
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        if parent == nil {
            imagesLoadingQueue.cancelAllOperations()
        }
    }
    
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCellID", forIndexPath: indexPath) as! ImageCell
        cell.image = images[indexPath.row]
        return cell
    }

    private let CATegory = "cats"
    private let size = CGSizeMake(100, 100)
    
    internal func loadNextImage() {
        var nextIndex = images.count
        let nextImageOperations = [
            ImageLoadingOperation(category: CATegory, size: size, index: ++nextIndex),
            ImageLoadingOperation(category: CATegory, size: size, index: ++nextIndex),
            ImageLoadingOperation(category: CATegory, size: size, index: ++nextIndex),
        ]
        
        // REPLACE HERE WITH [weak self] and guard
        let updateOperation = NSBlockOperation { [unowned self] in
//            guard let sself = self else { return }
            let images = nextImageOperations.map({ $0.result.asOptional }).filter({ $0 != nil }).map { $0! }
            for image in images {
                self.images.append(image)
            }
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.title = "Loaded: \(self.images.count)"
                self.imagesView.reloadData()
            }
        }
        nextImageOperations.forEach(NSBlockOperation.addDependency(updateOperation))
        
        imagesLoadingQueue.addOperations(nextImageOperations, waitUntilFinished: false)
        imagesLoadingQueue.addOperation(updateOperation)
    }
}

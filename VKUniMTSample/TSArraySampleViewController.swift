//
//  TSArraySampleViewController.swift
//  VKUniMTSample
//
//  Created by Dmitry Zakharov on 26/11/15.
//  Copyright © 2015 VKontakte. All rights reserved.
//

import UIKit

internal class TSArraySampleViewController: BaseSampleViewController {

    @IBOutlet weak var numberOfItemsLabel: UILabel!
    
    private func setNumberOfItemsLabelValue(value: Int) {
        self.numberOfItemsLabel.text = "Number of items: \(DefaultNumberFormatter.stringFromNumber(value)!)"
    }
    
    override class var sampleDescriptor: SampleDescriptor! {
        return SampleDescriptor(title: "\'Thread-safe Array\' sample", storyboardID: "TSArraySampleViewController")
    }
    
    private let numberOfItems = 10
    private var numbers = [Int]()
    
    @IBAction func printResultTapped() {
        NSLog("Result: %@", self.numbers)
    }

    private func runInGroup(group: dispatch_group_t, block: dispatch_block_t) {
        dispatch_group_async(group, dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), block)
    }
    
    @IBAction func threadSafeTapped() {
        let result = ThreadSafeArray<Int>() // SpinLockArray<Int>, SerialArray<Int>
        
        let group = dispatch_group_create()
        
        for var index = 0; index < numberOfItems; ++index {
            runInGroup(group) {
                result.append(index)
            }
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            self.numbers = result.extract
            self.setNumberOfItemsLabelValue(result.count)
        }
    }
    
    @IBAction func nonthreadSafeTapped() {
        var result = [Int]()
        result.reserveCapacity(numberOfItems)
        
        let group = dispatch_group_create()
        
        for var index = 0; index < numberOfItems; ++index {
            runInGroup(group) {
                result.append(index)
            }
        }

        dispatch_group_notify(group, dispatch_get_main_queue()) {
            self.numbers = result
            self.setNumberOfItemsLabelValue(result.count)
        }
    }
}

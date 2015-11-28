//
//  GCDSampleViewController.swift
//  VKUniMTSample
//
//  Created by Dmitry Zakharov on 28/11/15.
//  Copyright © 2015 VKontakte. All rights reserved.
//

import UIKit

internal class GCDSampleViewController: BaseSampleViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override class var sampleDescriptor: SampleDescriptor! {
        return SampleDescriptor(title: "\'GCD Queues\' sample", storyboardID: "GCDSampleViewController")
    }

    private let priorities = [
        DISPATCH_QUEUE_PRIORITY_BACKGROUND,
        DISPATCH_QUEUE_PRIORITY_LOW,
        DISPATCH_QUEUE_PRIORITY_DEFAULT,
        DISPATCH_QUEUE_PRIORITY_HIGH
    ]
    
    private var data = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Priorities", style: .Plain, target: self, action: Selector("calculatePriorities"))
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PriorityCellID", forIndexPath: indexPath)
        cell.textLabel!.text = priorityNameFromIndex(indexPath.row)
        cell.detailTextLabel!.text = PreciseNumberFormatter.stringFromNumber(data[indexPath.row])
        return cell
    }
    
    private func priorityNameFromIndex(index: Int) -> String {
        switch index {
        case 0: return "BACKGROUND"
        case 1: return "LOW"
        case 2: return "DEFAULT"
        case 3: return "HIGH"
        case _: return "UNKNOWN"
        }
    }
    
    internal func calculatePriorities() {
        let group = dispatch_group_create()
        
        data = [Double](count: priorities.count, repeatedValue: 0)
        for (index, queue) in priorities.map({p in dispatch_get_global_queue(p, 0)}).enumerate() {
            dispatch_group_enter(group)
            dispatch_async(queue) {
                self.data[index] = NSThread.currentThread().threadPriority
                dispatch_group_leave(group)
            }
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
}

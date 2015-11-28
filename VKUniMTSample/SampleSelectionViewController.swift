//
//  SampleSelectionViewController.swift
//  VKUniMTSample
//
//  Created by Dmitry Zakharov on 26/11/15.
//  Copyright © 2015 VKontakte. All rights reserved.
//

import UIKit

class SampleSelectionViewController: UITableViewController {
    private let samples = [
        GCDSampleViewController.sampleDescriptor,
        ApplyFunctionSampleViewController.sampleDescriptor,
        TSArraySampleViewController.sampleDescriptor,
        NSOperationQueueSampleViewController.sampleDescriptor,
        ProducerConsumerSampleViewController.sampleDescriptor,
        FileSystemSampleViewController.sampleDescriptor
    ]

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return samples.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SampleCellID", forIndexPath: indexPath)
        cell.textLabel?.text = samples[indexPath.row].title
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let sb = storyboard, nc = navigationController {
            nc.pushViewController(sb.instantiateViewControllerWithIdentifier(samples[indexPath.row].storyboardID), animated: true)
        }
    }
}

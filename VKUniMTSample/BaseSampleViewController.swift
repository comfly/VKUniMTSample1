//
//  BaseSampleViewController.swift
//  VKUniMTSample
//
//  Created by Dmitry Zakharov on 26/11/15.
//  Copyright © 2015 VKontakte. All rights reserved.
//

import UIKit

class BaseSampleViewController: UIViewController {
    internal class var sampleDescriptor: SampleDescriptor! {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = self.dynamicType.sampleDescriptor.title
        
        dimmer.backgroundColor = UIColor(white: CGFloat(0), alpha: CGFloat(0.4))
        dimmer.frame = view.bounds
        view.addSubview(dimmer)

        let indicatorSize = CGFloat(80)
        indicator.frame = CGRectMake(CGRectGetMidX(view.bounds) - indicatorSize / 2, CGRectGetMidY(view.bounds) - indicatorSize / 2, indicatorSize, indicatorSize)
        indicator.hidesWhenStopped = true
        view.addSubview(indicator)
        
        stopProgressAnimation()
    }
    
    private let indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    private let dimmer = UIView()
    
    internal func startProgressAnimation() {
        dimmer.hidden = false
        indicator.hidden = false
        indicator.startAnimating()
    }
    
    internal func stopProgressAnimation() {
        dimmer.hidden = true
        indicator.stopAnimating()
    }
}

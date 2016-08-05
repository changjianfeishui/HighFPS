//
//  ViewController.swift
//  HighFPS
//
//  Created by XB on 16/8/5.
//  Copyright © 2016年 XB. All rights reserved.
//

import UIKit
import AVFoundation
protocol VideoViewDelegate {
    func setupSession(session:AVCaptureSession)
}

class ViewController: UIViewController {
    
    var videoLayer: AVCaptureVideoPreviewLayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func setupVideoLayer() {
        self.videoLayer = AVCaptureVideoPreviewLayer()
        self.videoLayer.frame = self.view.bounds;
        self.view.layer.addSublayer(self.videoLayer)
    }

}

extension ViewController:VideoViewDelegate{
    func setupSession(session: AVCaptureSession) {
        self.videoLayer.session = session
    }
}
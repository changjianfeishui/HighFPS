//
//  ViewController.swift
//  HighFPS
//
//  Created by XB on 16/8/5.
//  Copyright © 2016年 XB. All rights reserved.
//

import UIKit
import AVFoundation
protocol VideoViewDelegate: NSObjectProtocol{
    func setupSession(session:AVCaptureSession)
}

class VideoVC: UIViewController {
    
    var videoLayer: AVCaptureVideoPreviewLayer!
    var presenter: VideoPresenterDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupVideoLayer()
        self.presenter = VideoPresenter(view: self)
        self.presenter.startVideoCapture()
        self.presenter.startHighFPSCapture()
    }

    func setupVideoLayer() {
        self.videoLayer = AVCaptureVideoPreviewLayer()
        self.videoLayer.frame = self.view.bounds;
        self.view.layer.addSublayer(self.videoLayer)
    }
}

extension VideoVC:VideoViewDelegate{
    func setupSession(session: AVCaptureSession) {
        self.videoLayer.session = session
    }
}
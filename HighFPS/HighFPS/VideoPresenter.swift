//
//  VideoPresenter.swift
//  HighFPS
//
//  Created by XB on 16/8/8.
//  Copyright © 2016年 XB. All rights reserved.
//

import UIKit
protocol VideoPresenterDelegate: NSObjectProtocol{
    func startVideoCapture()
    func stopVideoCapture()
    func startHighFPSCapture()
}


class VideoPresenter: NSObject {
    
    weak private var view: VideoViewDelegate?
    private var captureModel = CaptureModel()
    convenience init(view:VideoViewDelegate) {
        self.init()
        self.view = view
        if self.captureModel.setupSession() {
            self.view?.setupSession(self.captureModel.session)
        }
    }
}

extension VideoPresenter:VideoPresenterDelegate
{
    func startVideoCapture(){
        self.captureModel.startSession()
    }
    
    func stopVideoCapture(){
        self.captureModel.stopSession()
    }

    func startHighFPSCapture()
    {
        self.captureModel.startHighFPSCapture()
    }

}

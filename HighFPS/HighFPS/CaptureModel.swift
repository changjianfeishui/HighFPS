//
//  CaptureModel.swift
//  HighFPS
//
//  Created by XB on 16/8/5.
//  Copyright © 2016年 XB. All rights reserved.
//

import UIKit
import AVFoundation

class CaptureModel {
    
}



extension AVCaptureDevice{
    //判断当前设备是否支持高帧率捕捉
    func supportHighFPSCapture() -> Bool {
        return false
    }
    
    func enableHighFPSCapture() -> Bool {
        return false
    }
}




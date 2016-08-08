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
    var session:AVCaptureSession!
    let videoQueue = dispatch_queue_create("HighFPS",nil)

    var videoInput:AVCaptureDeviceInput!
    
    //初始化捕捉会话
    func setupSession() -> Bool {
        self.session = AVCaptureSession()
        self.session.sessionPreset = AVCaptureSessionPresetHigh;
        //设置输入
        if !self.setupInput() {
            return false
        }
        
        //设置输出
        if !self.setupOutput() {
            return false
        }
        
        return true

    }
    
    private func setupInput() -> Bool {
        //视频
        let videoDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        self.videoInput = try? AVCaptureDeviceInput(device: videoDevice)
        if self.videoInput == nil {
            return false
        }
        if self.session.canAddInput(self.videoInput) {
            self.session.addInput(self.videoInput)
        }else{
            return false
        }
        
        //音频
        let audioDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
        let audioInput = try? AVCaptureDeviceInput(device: audioDevice)
        if audioInput == nil {
            return false
        }
        if self.session.canAddInput(audioInput) {
            self.session.addInput(audioInput)
        }else{
            return false
        }
        
        
        return true
    }
    
    private func setupOutput() -> Bool {
        //Demo省略了视频的保存及不同播放倍率的预览播放,所以直接返回true
        return true
    }
    
    func startSession() {
        if !self.session.running {
            dispatch_async(self.videoQueue, {
                self.session.startRunning()
            })
        }
    }
    
    func stopSession() -> Void {
        if self.session.running {
            dispatch_async(self.videoQueue, {
                self.session.stopRunning()
            })
        }
    }
    
    //激活高帧率捕捉
    func startHighFPSCapture() {
        let device = self.videoInput.device
        //6plus真机实测最高支持240FPS的视频录制
        if  let (maxFormat,maxFrameRateRange) = device.maxFPSFormat() {
            if ((try? device.lockForConfiguration()) != nil) {
                //处理帧时长数据,比如帧率为60FPS,则duration为1/60秒
                let minFrameDuration = maxFrameRateRange.minFrameDuration
                device.activeFormat = maxFormat
                device.activeVideoMaxFrameDuration = minFrameDuration
                device.activeVideoMinFrameDuration = minFrameDuration
                device.unlockForConfiguration()
            }
        }
    }
    
}

//AVCaptureDevice类扩展
extension AVCaptureDevice{
    //如果当前设备是否支持高帧率捕捉,则返回对应的高帧率format
    func maxFPSFormat() -> (AVCaptureDeviceFormat,AVFrameRateRange)? {
        //1. 判断是否是视频设备
        if !self.hasMediaType(AVMediaTypeVideo) {
            return nil
        }
        //2. 遍历找到最大的支持帧率
        var maxFrameRateRange:AVFrameRateRange!
        var maxFormat:AVCaptureDeviceFormat!
        for format in self.formats as! [AVCaptureDeviceFormat] {
            let codecType = CMFormatDescriptionGetMediaSubType(format.formatDescription)
            if codecType == kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange {
                let frameRateRanges = format.videoSupportedFrameRateRanges as! [AVFrameRateRange]
                for range in frameRateRanges {
                    if range.maxFrameRate > maxFrameRateRange?.maxFrameRate {
                        maxFrameRateRange = range
                        maxFormat = format
                    }
                }
            }
        }
        if maxFrameRateRange.maxFrameRate > 30 {
            return (maxFormat,maxFrameRateRange)
        }
        return nil
    }
}




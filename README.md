# 核心代码
## 判断当前视频设备是否支持高帧率视频采集

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

## 激活高帧率视频捕捉

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
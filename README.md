# CustomVideoCapture
利用AVFoundation 实现视频的录制，播放功能和相机拍照功能。 

//使用AVFoundation拍照和录制视频的一般步骤如下：

//创建AVCaptureSession对象。

//使用AVCaptureDevice的静态方法获得需要使用的设备，例如拍照和录像就需要获得摄像头设备，录音就要获得麦克风设备。

//利用输入设备AVCaptureDevice初始化AVCaptureDeviceInput对象。

//初始化输出数据管理对象，如果要拍照就初始化AVCaptureStillImageOutput对象；如果拍摄视频就初始化AVCaptureMovieFileOutput对象。

//将数据输入对象AVCaptureDeviceInput、数据输出对象AVCaptureOutput添加到媒体会话管理对象AVCaptureSession中。

//创建视频预览图层AVCaptureVideoPreviewLayer并指定媒体会话，添加图层到显示容器中，调用AVCaptureSession的startRuning方法开始捕获。

//将捕获的音频或视频数据输出到指定文件。
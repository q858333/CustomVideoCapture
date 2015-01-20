//
//  DBTabkePhotoVC.m
//  CustomVideoCapture
//
//  Created by dengbin on 15/1/15.
//  Copyright (c) 2015年 IUAIJIA. All rights reserved.
//

#import "DBTabkePhotoVC.h"
#import "UIImage+Rotate.h"
@interface DBTabkePhotoVC ()

@end

@implementation DBTabkePhotoVC
//拍照
//-(void)capture
//{
//    NSLog(@"capture");
//    
//    
//    
//    AVCaptureConnection *videoConnection = nil;
//    for (AVCaptureConnection *connection in self.imageOutPut.connections)
//    {
//        for (AVCaptureInputPort *port in [connection inputPorts])
//        {
//            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
//            {
//                videoConnection = connection;
//                break;
//            }
//        }
//        
//        if (videoConnection)
//        {
//            break;
//        }
//    }
//    
//    [self.imageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection
//                                                  completionHandler:
//     ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
//         
//         //图像数据类型转换
//         NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
//         UIImage * image = [[UIImage alloc] initWithData:imageData];
//         
//         UIImage *image2 = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationRight];
//         UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 320)];
//         imgView.image=image2;
//         [self.view addSubview:imgView];//         [_delegate wtImagePickerVC:self didPickImage:image];
//         //         captureButton.userInteractionEnabled = NO;
//         
//         
//     }];
//}

//定义闪光灯开闭及自动模式功能，注意无论是设置闪光灯、白平衡还是其他输入设备属性，在设置之前必须先锁定配置，修改完后解锁。
/** *  改变设备属性的统一操作方法 * *  @param propertyChange 属性改变操作 */
//-(void)changeDeviceProperty:(PropertyChangeBlock)propertyChange
//{
//    AVCaptureDevice *captureDevice= [self.captureDeviceInput device];
//    NSError *error;
//    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
//    if ([captureDevice lockForConfiguration:&error])
//    {
//        propertyChange(captureDevice);
//        [captureDevice unlockForConfiguration];
//    }else
//    {
//        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
//    }
//}
/** *  设置闪光灯模式 * *  @param flashMode 闪光灯模式 */
//-(void)setFlashMode:(AVCaptureFlashMode )flashMode
//{
//    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice)
//     {
//         if ([captureDevice isFlashModeSupported:flashMode])
//     {
//         [captureDevice setFlashMode:flashMode];
//     }
//         
//     
//     
//     }];
//}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self initCapture];
    [self initView];
 //   [self start];
    
   // [layer insertSublayer:_captureVideoPreviewLayer below:self.focusCursor.layer];
//    [self addNotificationToCaptureDevice:captureDevice];
    [self addGenstureRecognizer];
//    [self setFlashModeButtonStatus];
}
-(void)initView
{
    NSArray *flashs=@[@"关闭",@"打开",@"自动"];
    
    for (int i = 0 ; i<flashs.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:flashs[i] forState:UIControlStateNormal];
        button.tag=i;
        [button addTarget:self action:@selector(flashBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame=CGRectMake(60*i, 0, 44, 44);
        [self.view addSubview:button];
    }
    
    
    UIButton *takePhotoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [takePhotoBtn setTitle:@"拍照" forState:UIControlStateNormal];
    takePhotoBtn.frame=CGRectMake(0, 320+44, 320, 44);
    [takePhotoBtn addTarget:self action:@selector(takePhotoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:takePhotoBtn];
    
    
    UIButton *toggleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [toggleButton setTitle:@"切换摄像头" forState:UIControlStateNormal];
    toggleButton.frame=CGRectMake(0, 320+88, 320, 44);
    [toggleButton addTarget:self action:@selector(toggleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:toggleButton];
}
-(void)flashBtnClick:(UIButton *)sender
{
    [self setFlashMode:sender.tag];
    NSLog(@"%d",sender.tag);
   
}


-(void)initCapture
{
    //初始化会话
    _captureSession=[[AVCaptureSession alloc]init];
    [_captureSession startRunning];

    [_captureSession setSessionPreset:AVCaptureSessionPreset352x288];

//    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720])
//    {//设置分辨率
//        _captureSession.sessionPreset=AVCaptureSessionPreset1280x720;
//    }
    
    //  AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    
    //获得输入设备
    //取得后置摄像头
    AVCaptureDevice *captureDevice=[self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
    if (!captureDevice)
    {
        NSLog(@"取得后置摄像头时出现问题.");
        return;
    }
    NSError *error=nil;
    
    //根据输入设备初始化设备输入对象，用于获得输入数据
    self.captureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:captureDevice error:&error];

    if (error)
    {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    
    //初始化设备输出对象，用于获得输出数据
    _captureStillImageOutput=[[AVCaptureStillImageOutput alloc]init];
    NSDictionary *outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
    
    [_captureStillImageOutput setOutputSettings:outputSettings];
    
    //输出设置        //将设备输入添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput])
    {
        [_captureSession addInput:_captureDeviceInput];
    }
    
    //将设备输出添加到会话中
    if ([_captureSession canAddOutput:_captureStillImageOutput])
    {
        [_captureSession addOutput:_captureStillImageOutput];
    }
    
    //创建视频预览层，用于实时展示摄像头状态
    _captureVideoPreviewLayer=[[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
    
    self.containerView=[[UIView alloc]initWithFrame:CGRectMake(0, 44, 320, 320)];
    
    [self.view addSubview:self.containerView];
    
    CALayer *layer=self.containerView.layer;
    layer.masksToBounds=YES;
    _captureVideoPreviewLayer.frame=layer.bounds;
    _captureVideoPreviewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    
    //填充模式
    //将视频预览层添加到界面中
    [layer addSublayer:_captureVideoPreviewLayer];
    
    
    self.focusCursorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.focusCursorView.layer.borderColor=[UIColor whiteColor].CGColor;
    self.focusCursorView.layer.borderWidth=2;
    self.focusCursorView.alpha=0;
    [self.containerView addSubview:self.focusCursorView];
    
    
    

}

-(void)start
{
    if (_captureSession)
    {
        [_captureSession startRunning];

    }
}

-(void)stop
{
    if (_captureSession)
    {
        [_captureSession stopRunning];
        
    }
}

-(void)takePhotoBtnClick
{


//    
//    AVCaptureConnection *videoConnection = nil;
//    for (AVCaptureConnection *connection in self.captureStillImageOutput.connections)
//    {
//        for (AVCaptureInputPort *port in [connection inputPorts]) {
//            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
//                videoConnection = connection;
//                break;
//            }
//        }
//        if (videoConnection) { break; }
//    }
    //根据设备输出获得连接
    AVCaptureConnection *videoConnection=[self.captureStillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    
    [self.captureStillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error)
     {
         [self stop];
         
         if (imageDataSampleBuffer)
         {
             NSData *imageData=[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
             UIImage *image=[UIImage imageWithData:imageData];
             [UIImage rotateImage:image];
             //  [self.captureSession stopRunning];
             UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, 320, 320)];
             //   imgView.image=[self scaleImage:image toScale:<#(float)#>];
             imgView.contentMode=UIViewContentModeScaleAspectFill;
             
             [self.view addSubview:imgView];
             imgView.image=image;
             
             // = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, 44, 320, 320)) scale:1 orientation:UIImageOrientationRight];
             //             [UIimage imagewidthCGImage:CGImageCreateWidthImageInRec]
             //             [UIimage imagewidthCGImage:CGImageCreateWidthImageInRect:(,矩形)]
             
             
              UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
             
//                         ALAssetsLibrary *assetsLibrary=[[ALAssetsLibrary alloc]init];
//                         [assetsLibrary writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:nil];
             
         }
     }];
    

    //根据连接取得设备输出的数据
    
}


#pragma mark 切换前后摄像头

- (void)toggleButtonClick
{
    AVCaptureDevice *currentDevice=[self.captureDeviceInput device];
    AVCaptureDevicePosition currentPosition=[currentDevice position];
    
    AVCaptureDevice *toChangeDevice;
    AVCaptureDevicePosition toChangePosition=AVCaptureDevicePositionFront;
    if (currentPosition==AVCaptureDevicePositionUnspecified||currentPosition==AVCaptureDevicePositionFront)
    {
        toChangePosition=AVCaptureDevicePositionBack;
    }
    toChangeDevice=[self getCameraDeviceWithPosition:toChangePosition];
    //获得要调整的设备输入对象
    AVCaptureDeviceInput *toChangeDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:toChangeDevice error:nil];
    //改变会话的配置前一定要先开启配置，配置完成后提交配置改变
    [self.captureSession beginConfiguration];
    //移除原有输入对象
    [self.captureSession removeInput:self.captureDeviceInput];
    //添加新的输入对象
    if ([self.captureSession canAddInput:toChangeDeviceInput])
    {
        [self.captureSession addInput:toChangeDeviceInput];
        self.captureDeviceInput=toChangeDeviceInput;
    }
    //提交会话配置
    [self.captureSession commitConfiguration];
}
//#pragma mark 切换前后摄像头
//- (IBAction)toggleButtonClick:(UIButton *)sender
//{
//    AVCaptureDevice *currentDevice=[self.captureDeviceInput device];
//    AVCaptureDevicePosition currentPosition=[currentDevice position];
//    [self removeNotificationFromCaptureDevice:currentDevice];
//    AVCaptureDevice *toChangeDevice;
//    AVCaptureDevicePosition toChangePosition=AVCaptureDevicePositionFront;
//    
//    if (currentPosition==AVCaptureDevicePositionUnspecified||currentPosition==AVCaptureDevicePositionFront)
//    {
//        toChangePosition=AVCaptureDevicePositionBack;
//    }
//    toChangeDevice=[self getCameraDeviceWithPosition:toChangePosition];
//    [self addNotificationToCaptureDevice:toChangeDevice];
//    //获得要调整的设备输入对象
//    AVCaptureDeviceInput *toChangeDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:toChangeDevice error:nil];
//    //改变会话的配置前一定要先开启配置，配置完成后提交配置改变
//    [self.captureSession beginConfiguration];
//    //移除原有输入对象
//    [self.captureSession removeInput:self.captureDeviceInput];
//    //添加新的输入对象
//    if ([self.captureSession canAddInput:toChangeDeviceInput])
//    {
//        [self.captureSession addInput:toChangeDeviceInput];
//        self.captureDeviceInput=toChangeDeviceInput;
//    }    //提交会话配置
//    [self.captureSession commitConfiguration];
//    [self setFlashModeButtonStatus];}
//

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//添加点击手势操作，点按预览视图时进行聚焦、白平衡设置。
/** *  设置聚焦点 * *  @param point 聚焦点 */
-(void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point
{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice)
    {
        if ([captureDevice isFocusModeSupported:focusMode])
        {
            [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        if ([captureDevice isFocusPointOfInterestSupported])
        {
            [captureDevice setFocusPointOfInterest:point];
        }
        if ([captureDevice isExposureModeSupported:exposureMode])
        {
            [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        if ([captureDevice isExposurePointOfInterestSupported])
        {
            [captureDevice setExposurePointOfInterest:point];
        }
    }];
}

/** *  改变设备属性的统一操作方法 * *  @param propertyChange 属性改变操作 */
-(void)changeDeviceProperty:(PropertyChangeBlock)propertyChange
{
    AVCaptureDevice *captureDevice= [self.captureDeviceInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error])
    {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }
    else
    {
        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}
/** *  设置闪光灯模式 * *  @param flashMode 闪光灯模式 */
-(void)setFlashMode:(AVCaptureFlashMode )flashMode
{
    
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice)
    {
        if ([captureDevice isFlashModeSupported:flashMode])
        {
            [captureDevice setFlashMode:flashMode];
        }
    }];
}
/** *  设置闪光灯按钮状态 */
//-(void)setFlashModeButtonStatus
//{
//    AVCaptureDevice *captureDevice=[self.captureDeviceInput device];
//    AVCaptureFlashMode flashMode=captureDevice.flashMode;
//    if([captureDevice isFlashAvailable])
//    {
//        self.flashAutoButton.hidden=NO;
//        self.flashOnButton.hidden=NO;
//        self.flashOffButton.hidden=NO;
//        self.flashAutoButton.enabled=YES;
//        self.flashOnButton.enabled=YES;
//        self.flashOffButton.enabled=YES;
//        switch (flashMode) {
//            case AVCaptureFlashModeAuto:
//            self.flashAutoButton.enabled=NO;
//            break;
//            case AVCaptureFlashModeOn:
//            self.flashOnButton.enabled=NO;
//            break;
//            case AVCaptureFlashModeOff:
//            self.flashOffButton.enabled=NO;
//            break;
//                
//            default:
//            break;
//        }
//    }else
//    {
//        self.flashAutoButton.hidden=YES;
//        self.flashOnButton.hidden=YES;
//        self.flashOffButton.hidden=YES;
//    }
//}
/** *  添加点按手势，点按时聚焦 */
-(void)addGenstureRecognizer
{
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];    [self.containerView addGestureRecognizer:tapGesture];
}
-(void)tapScreen:(UITapGestureRecognizer *)tapGesture
{
    CGPoint point= [tapGesture locationInView:self.containerView];
    //将UI坐标转化为摄像头坐标
    CGPoint cameraPoint= [self.captureVideoPreviewLayer captureDevicePointOfInterestForPoint:point];
    [self setFocusCursorWithPoint:point];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
}

/** *  设置聚焦光标位置 * *  @param point 光标位置 */
-(void)setFocusCursorWithPoint:(CGPoint)point
{
    self.focusCursorView.center=point;
    self.focusCursorView.transform=CGAffineTransformMakeScale(1.5, 1.5);
    self.focusCursorView.alpha=1.0;
    [UIView animateWithDuration:1.0 animations:^{
        self.focusCursorView.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finished)
     {
         self.focusCursorView.alpha=0;
     }];
}
/** 
 *  取得指定位置的摄像头 * *@param position 摄像头位置 * * @return 摄像头设备
 */
-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position
{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras)
    {
        if ([camera position]==position)
        {
            return camera;
        }
    }
    return nil;
}


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  ViewController.m
//  CustomVideoCapture
//
//  Created by dengbin on 15/1/14.
//  Copyright (c) 2015年 IUAIJIA. All rights reserved.
//

#import "ViewController.h"
#import "DBTakePhotoVC.h"
#import "DBTakeVideoVC.h"
//使用AVFoundation拍照和录制视频的一般步骤如下：
//创建AVCaptureSession对象。
//使用AVCaptureDevice的静态方法获得需要使用的设备，例如拍照和录像就需要获得摄像头设备，录音就要获得麦克风设备。
//利用输入设备AVCaptureDevice初始化AVCaptureDeviceInput对象。
//初始化输出数据管理对象，如果要拍照就初始化AVCaptureStillImageOutput对象；如果拍摄视频就初始化AVCaptureMovieFileOutput对象。
//将数据输入对象AVCaptureDeviceInput、数据输出对象AVCaptureOutput添加到媒体会话管理对象AVCaptureSession中。
//创建视频预览图层AVCaptureVideoPreviewLayer并指定媒体会话，添加图层到显示容器中，调用AVCaptureSession的startRuning方法开始捕获。
//将捕获的音频或视频数据输出到指定文件。



@interface ViewController ()
{
}

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    UIButton *takePhotoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [takePhotoBtn setTitle:@"拍照" forState:UIControlStateNormal];
    [takePhotoBtn addTarget:self action:@selector(takePhotoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    takePhotoBtn.frame=CGRectMake(0, 100, 320, 50);
    [self.view addSubview:takePhotoBtn];
    
    
    UIButton *takeVideoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [takeVideoBtn setTitle:@"录像" forState:UIControlStateNormal];
    [takeVideoBtn addTarget:self action:@selector(takeVideoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    takeVideoBtn.frame=CGRectMake(0, 200, 320, 50);
    [self.view addSubview:takeVideoBtn];
    

    
    
//    
//    self.imageOutPut = [[AVCaptureStillImageOutput alloc] init];
//    NSDictionary *outputSettings = @{ AVVideoCodecKey : AVVideoCodecJPEG};
//    [self.imageOutPut setOutputSettings:outputSettings];
//    [_captureSession beginConfiguration];
//    [_captureSession addOutput: self.imageOutPut];
//    [_captureSession commitConfiguration];
    

    
    // Do any additional setup after loading the view, typically from a nib.
}


-(void)takeVideoBtnClick
{
    DBTakeVideoVC *takeVideoVC=[[DBTakeVideoVC alloc]init];
    [self presentViewController:takeVideoVC animated:YES completion:nil];
}
-(void)takePhotoBtnClick
{
    DBTakePhotoVC *takePhotoVC=[[DBTakePhotoVC alloc]init];
    [self presentViewController:takePhotoVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

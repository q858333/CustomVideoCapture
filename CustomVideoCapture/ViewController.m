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




@interface ViewController ()
{
}

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor blackColor];
    
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
    [self.navigationController pushViewController:takeVideoVC animated:YES];
   // [self presentViewController:takeVideoVC animated:YES completion:nil];
}
-(void)takePhotoBtnClick
{
    DBTakePhotoVC *takePhotoVC=[[DBTakePhotoVC alloc]init];
    [self.navigationController pushViewController:takePhotoVC animated:YES];

    //  [self presentViewController:takePhotoVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

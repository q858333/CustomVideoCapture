//
//  DBPlayVideoVC.m
//  CustomVideoCapture
//
//  Created by dengbin on 15/1/19.
//  Copyright (c) 2015年 IUAIJIA. All rights reserved.
//

#import "DBPlayVideoVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

#define COUNT_DUR_TIMER_INTERVAL  0.025

@interface DBPlayVideoVC ()
{
    MPMoviePlayerController *_mp_player;
    
    UIProgressView   *_progressView;
    UIButton         *_startBtn;
    NSTimer          *_timer;
    NSInteger         _int_count;//播放时间
    
    BOOL  _playBeginState;
    BOOL  _isPause;
}

@property (nonatomic ,strong) AVPlayer *player;
@property (nonatomic ,strong) AVPlayerItem *playerItem;

@end

@implementation DBPlayVideoVC

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor redColor];

    
    [self initPlayer];//创建播放器
    [self initView];//创建按钮 进度

    //播放结束
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(playerItemDidReachEnd:)
                                                 name: AVPlayerItemDidPlayToEndTimeNotification
                                               object: self.playerItem];
    

//   _mp_player  = [[MPMoviePlayerController alloc] initWithContentURL:self.fileURL];
//    _mp_player.view.frame=CGRectMake(0, 0, 200, 200);
//    
//    _mp_player.scalingMode = MPMovieScalingModeAspectFit;
//    [_mp_player setFullscreen:YES animated:YES];
//    [_mp_player prepareToPlay];
//    
//    [_mp_player play];
//    [self.view addSubview:_mp_player.view];
  
    
}
//横评播放
//- (NSUInteger)supportedInterfaceOrientations
//{
//    
//    return UIInterfaceOrientationMaskLandscape;
//}
-(void)initPlayer
{
    
    
    AVURLAsset *movieAsset    = [[AVURLAsset alloc]initWithURL:self.fileURL options:nil];
    
    
    self.playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    
    [self.playerItem addObserver:self forKeyPath:@"status" options:0 context:NULL];
    
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
    playerLayer.frame = self.view.layer.bounds;
    
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    [self.view.layer addSublayer:playerLayer];
    
    [self.player setAllowsExternalPlayback:YES];
    
    

}
-(void)initView
{
    
    _startBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_startBtn setTitle:@"开始" forState:UIControlStateNormal];
    _startBtn.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.5];
    _startBtn.frame=self.view.layer.bounds;
    [_startBtn addTarget:self action:@selector(startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startBtn];
    
    
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 50, 320, 10)];
    _progressView.progress=0;
    [self.view addSubview:_progressView];
    
    UIButton  *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    backBtn.frame=CGRectMake(0, 0, 44, 44);
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];

}

#pragma mark - BtnClick

-(void)backBtnClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)startBtnClick:(UIButton *)sender
{
    
    if([sender.titleLabel.text isEqualToString:@"开始"])
    {

        [self startPlay];//开始

    }else if ([sender.titleLabel.text isEqualToString:@"重播"])
    {
        
        [self rePlay];//重播
        
    }else if ([sender.titleLabel.text isEqualToString:@"继续播放"])
    {
        [self continuePlay];//继续播放

    }else
    {
        [self pauesPlay];//暂停
    }

}

#pragma mark - 计时器操作
-(void)startTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:COUNT_DUR_TIMER_INTERVAL target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}

-(void)onTimer
{
    
    if (!_isPause)
    {
        _progressView.progress+=(COUNT_DUR_TIMER_INTERVAL/[self playableDuration]);
    }

}
-(void)endTimer
{
    [_timer invalidate];
    _timer=nil;
}

#pragma mark - 播放器状态
//重播
-(void)rePlay
{
    _startBtn.titleLabel.text=@"";
    [_startBtn setTitle:@"" forState:UIControlStateNormal];
    _startBtn.backgroundColor=[UIColor clearColor];

   
    AVPlayerItem *playerItem = [self.player currentItem];
    // Set it back to the beginning
    [playerItem seekToTime: kCMTimeZero];
    // Tell the player to do nothing when it reaches the end of the video
    // -- It will come back to this method when it's done
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    // Play it again, Sam
    [self.player play];
    
    _progressView.progress=0;
    _isPause=NO;
    [self startTimer];

}
//继续播放
-(void)continuePlay
{
    _startBtn.titleLabel.text=@"";
    [_startBtn setTitle:@"" forState:UIControlStateNormal];
    _startBtn.backgroundColor=[UIColor clearColor];
    [self.player play];
    _isPause=NO;


}
//暂停播放
-(void)pauesPlay
{
    _isPause=YES;
    [_startBtn setTitle:@"继续播放" forState:UIControlStateNormal];
    _startBtn.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.5];
    [self.player pause];

}
//开始播放
-(void)startPlay
{
    _startBtn.titleLabel.text=@"";
    [_startBtn setTitle:@"" forState:UIControlStateNormal];
    _startBtn.backgroundColor=[UIColor clearColor];
    [self.player play];
    
    [self startTimer];

    _isPause=NO;

}
//结束播放
-(void)endPlay
{
    [_startBtn setTitle:@"重播" forState:UIControlStateNormal];
    _startBtn.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.5];
    [self endTimer];
}
#pragma mark - 获取播放的时间
- (NSTimeInterval) playableDuration
{

    AVPlayerItem * item = self.playerItem;

    if (item.status == AVPlayerItemStatusReadyToPlay) {

        return CMTimeGetSeconds(self.playerItem.duration);

    }
    else
    {

        return(CMTimeGetSeconds(kCMTimeInvalid));

    }

}

- (NSTimeInterval) playableCurrentTime
{
    AVPlayerItem * item = self.playerItem;
    
    if (item.status == AVPlayerItemStatusReadyToPlay) {
        
   //     NSLog(@"%f\n",CMTimeGetSeconds(self.playerItem.currentTime));
        
        if (!_playBeginState&&CMTimeGetSeconds(self.playerItem.currentTime)==CMTimeGetSeconds(self.playerItem.duration)) {
            
            [self.player pause];
            
        }
        
        _playBeginState = NO;
        
        return CMTimeGetSeconds(self.playerItem.currentTime);
    }
    else
    {
        return(CMTimeGetSeconds(kCMTimeInvalid));
    }
}
#pragma mark - 加载视频完成
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"])
    {
        if (AVPlayerItemStatusReadyToPlay == self.player.currentItem.status)
        {
           // [self.player play];
 

            NSLog(@"准备播放");
//            NSLog(@"%lf",[self playableDuration]);
//            [UIView animateWithDuration:[self playableDuration] animations:^{
//            
//            }];

        }
    }
}
#pragma mark - 播放结束时
- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    // Loop the video

    [self endPlay];//播放停止
    
//        [self.player play];
//    }else {
//        mPlayer.actionAtItemEnd = AVPlayerActionAtItemEndAdvance;
//    }
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

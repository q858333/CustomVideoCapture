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
@interface DBPlayVideoVC ()
{
   // MPMoviePlayerController *_player;
    
    UIProgressView   *_progressView;
    
    BOOL  _playBeginState;
}

@property (nonatomic ,strong) AVPlayer *player;
@property (nonatomic ,strong) AVPlayerItem *playerItem;

@end

@implementation DBPlayVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    //存图片
    



    AVURLAsset *movieAsset    = [[AVURLAsset alloc]initWithURL:self.fileURL options:nil];
    
    
    self.playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    
    [self.playerItem addObserver:self forKeyPath:@"status" options:0 context:NULL];
    
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
    playerLayer.frame = self.view.layer.bounds;
    
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    [self.view.layer addSublayer:playerLayer];
    
    [self.player setAllowsExternalPlayback:YES];
    
    
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [startBtn setTitle:@"开始" forState:UIControlStateNormal];
    startBtn.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.5];
    startBtn.frame=self.view.layer.bounds;
    [startBtn addTarget:self action:@selector(startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    
    
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 20, 0, 20)];
    _progressView.progress=1;
    [self.view addSubview:_progressView];
    

//   _player  = [[MPMoviePlayerController alloc] initWithContentURL:self.fileURL];
//    _player.view.frame=CGRectMake(0, 0, 320, 480);
//    
// //   _player.scalingMode = MPMovieScalingModeAspectFit;
//  //  [_player setFullscreen:YES animated:YES];
//    [_player prepareToPlay];
//    
//    [_player play];
//    [self.view addSubview:_player.view];
  
    
    // Do any additional setup after loading the view.
}
-(void)startBtnClick:(UIButton *)sender
{
    [sender setTitle:@"" forState:UIControlStateNormal];
    sender.backgroundColor=[UIColor clearColor];
    [self.player play];

}
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
        
        NSLog(@"%f\n",CMTimeGetSeconds(self.playerItem.currentTime));
        
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"])
    {
        if (AVPlayerItemStatusReadyToPlay == self.player.currentItem.status)
        {
           // [self.player play];
            
            NSLog(@"%lf",[self playableDuration]);
            [UIView animateWithDuration:[self playableDuration] animations:^{
                _progressView.frame=CGRectMake(_progressView.frame.origin.x, _progressView.frame.origin.y, 320, _progressView.frame.size.height);
            
            }];

        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

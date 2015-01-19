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
}

@property (nonatomic ,strong) AVPlayer *player;
@property (nonatomic ,strong) AVPlayerItem *playerItem;

@end

@implementation DBPlayVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    

    AVURLAsset *movieAsset    = [[AVURLAsset alloc]initWithURL:self.fileURL options:nil];
    
    
    self.playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    
 //   [self. playerItem addObserver:self forKeyPath:@"status" options:0 context:NULL];
    
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
    playerLayer.frame = self.view.layer.bounds;
    
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    [self.view.layer addSublayer:playerLayer];
    
    [self.player setAllowsExternalPlayback:YES];
    
    
    [self.player play];

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

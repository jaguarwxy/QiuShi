//
//  XYNewPlayer.h
//  Tab
//
//  Created by zouxue on 15/9/16.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class AVPlayer;
@class PlayBackView;
@interface XYNewPlayer : UIView
{
    float mRestoreAfterScrubbingRate;
    BOOL seekToZeroBeforePlay;
    id mTimeObserver;
    BOOL isSeeking;
}

@property (nonatomic, copy) NSURL*  URL;
@property (readwrite, strong, setter=setPlayer:, getter=player) AVPlayer* player;
@property (strong) AVPlayerItem* playerItem;
@property (nonatomic, strong)  PlayBackView *playbackView;
@property (nonatomic, strong)  UIButton *playButton;
@property (nonatomic, strong)  UIBarButtonItem *stopButton;
@property (nonatomic, strong)  UISlider* scrubber;

- (void)play;
- (void)pause;

@end

@interface PlayBackView : UIView
@property (nonatomic, strong) AVPlayer* player;

- (void)setPlayer:(AVPlayer*)player;
- (void)setVideoFillMode:(NSString *)fillMode;
@end
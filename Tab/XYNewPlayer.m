//
//  XYNewPlayer.m
//  Tab
//
//  Created by zouxue on 15/9/16.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//

#import "XYNewPlayer.h"
#import <AVFoundation/AVFoundation.h>
static void *AVPlayerDemoPlaybackViewControllerRateObservationContext = &AVPlayerDemoPlaybackViewControllerRateObservationContext;
static void *AVPlayerDemoPlaybackViewControllerStatusObservationContext = &AVPlayerDemoPlaybackViewControllerStatusObservationContext;
static void *AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext = &AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext;

@interface XYNewPlayer ()
@end

@interface XYNewPlayer (Player)
- (void)removePlayerTimeObserver;
- (CMTime)playerItemDuration;
- (BOOL)isPlaying;
- (void)playerItemDidReachEnd:(NSNotification *)notification ;
- (void)observeValueForKeyPath:(NSString*) path ofObject:(id)object change:(NSDictionary*)change context:(void*)context;
- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys;
@end


#pragma mark -
@implementation XYNewPlayer

#pragma mark Asset URL
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self initControl];
        [self setPlayer:nil];
        isSeeking = NO;
        [self initScrubberTimer];
        
        [self syncPlayPauseButtons];
        [self syncScrubber];

    }
    return self;
}
-(void)initControl
{
    _playbackView=[[PlayBackView alloc] initWithFrame:self.bounds];
    [self addSubview:_playbackView];
    CGRect frame=self.bounds;
    frame.origin.y+=CGRectGetHeight(self.bounds)-30;
    _playButton=[[UIButton alloc] initWithFrame:CGRectMake(0, frame.origin.y, 30, 30)];
    [self addSubview:_playButton];
    [_playButton setTitle:@"播放" forState:UIControlStateNormal];
    [_playButton addTarget:self action:@selector(playOrpause) forControlEvents:UIControlEventTouchUpInside];
    _playButton.enabled=NO;
    _scrubber=[[UISlider alloc] initWithFrame:frame];
    [_scrubber addTarget:self action:@selector(scrub:) forControlEvents:UIControlEventTouchDragInside];
    [_scrubber addTarget:self action:@selector(endScrubbing:) forControlEvents:UIControlEventTouchUpInside];
    [_scrubber addTarget:self action:@selector(scrub:) forControlEvents:UIControlEventValueChanged];
    [_scrubber addTarget:self action:@selector(beginScrubbing:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:_scrubber];
}
- (void)setURL:(NSURL*)URL
{
    if (_URL!= URL)
    {
         _URL= [URL copy];
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:_URL options:nil];
        
        NSArray *requestedKeys = @[@"playable"];
        [asset loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:
         ^{
             dispatch_async( dispatch_get_main_queue(),
                            ^{
                                /* 必须主线程. */
                                [self prepareToPlayAsset:asset withKeys:requestedKeys];
                            });
         }];
    }
}

- (NSURL*)videoURL
{
    return _URL;
}
#pragma mark
#pragma mark Button Action Methods
-(void)playOrpause
{
    if ([self isPlaying])
    {
        [self.player pause];
        [self.playButton setTitle:@"播放" forState:UIControlStateNormal];
    }
    else
    {
        [self.player play];
        [self.playButton setTitle:@"暂停" forState:UIControlStateNormal];
    }

}
- (void)play
{
    if (YES == seekToZeroBeforePlay)
    {
        seekToZeroBeforePlay = NO;
        [self.player seekToTime:kCMTimeZero];
    }
    
    [self.player play];
    
    
}

- (void)pause
{
    [self.player pause];
}
#pragma mark Play, Stop buttons
- (void)syncPlayPauseButtons
{
    if ([self isPlaying])
    {
        [self.playButton setTitle:@"暂停" forState:UIControlStateNormal];
    }
    else
    {
        [self.playButton setTitle:@"播放" forState:UIControlStateNormal];
    }
}

-(void)enablePlayerButtons
{
    self.playButton.enabled = YES;
}

-(void)disablePlayerButtons
{
    self.playButton.enabled = NO;
}

#pragma mark Movie scrubber control
-(void)initScrubberTimer
{
    double interval = .1f;
    
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration))
    {
        return;
    }
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration))
    {
        CGFloat width = CGRectGetWidth([self.scrubber bounds]);
        interval = 0.5f * duration / width;
    }
    __weak XYNewPlayer *weakSelf = self;
    mTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(interval, NSEC_PER_SEC)
                                                               queue:NULL
                                                          usingBlock:^(CMTime time)
                     {
                         [weakSelf syncScrubber];
                     }];
}
- (void)syncScrubber
{
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration))
    {
        _scrubber.minimumValue = 0.0;
        return;
    }
    
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration))
    {
        float minValue = [self.scrubber minimumValue];
        float maxValue = [self.scrubber maximumValue];
        double time = CMTimeGetSeconds([self.player currentTime]);
        
        [self.scrubber setValue:(maxValue - minValue) * time / duration + minValue];
    }
}
- (void)beginScrubbing:(id)sender
{
    mRestoreAfterScrubbingRate = [self.player rate];
    [self.player setRate:0.f];
    
    [self removePlayerTimeObserver];
}
- (void)scrub:(id)sender
{
    if ([sender isKindOfClass:[UISlider class]] && !isSeeking)
    {
        isSeeking = YES;
        UISlider* slider = sender;
        
        CMTime playerDuration = [self playerItemDuration];
        if (CMTIME_IS_INVALID(playerDuration)) {
            return;
        }
        
        double duration = CMTimeGetSeconds(playerDuration);
        if (isfinite(duration))
        {
            float minValue = [slider minimumValue];
            float maxValue = [slider maximumValue];
            float value = [slider value];
            
            double time = duration * (value - minValue) / (maxValue - minValue);
            
            [self.player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC) completionHandler:^(BOOL finished) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    isSeeking = NO;
                });
            }];
        }
    }
}
- (void)endScrubbing:(id)sender
{
    if (!mTimeObserver)
    {
        CMTime playerDuration = [self playerItemDuration];
        if (CMTIME_IS_INVALID(playerDuration))
        {
            return;
        }
        
        double duration = CMTimeGetSeconds(playerDuration);
        if (isfinite(duration))
        {
            CGFloat width = CGRectGetWidth([self.scrubber bounds]);
            double tolerance = 0.5f * duration / width;
            
            __weak XYNewPlayer *weakSelf = self;
            mTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(tolerance, NSEC_PER_SEC) queue:NULL usingBlock:
                             ^(CMTime time)
                             {
                                 [weakSelf syncScrubber];
                             }];
        }
    }
    
    if (mRestoreAfterScrubbingRate)
    {
        [self.player setRate:mRestoreAfterScrubbingRate];
        mRestoreAfterScrubbingRate = 0.f;
    }
}

- (BOOL)isScrubbing
{
    return mRestoreAfterScrubbingRate != 0.f;
}

-(void)enableScrubber
{
    self.scrubber.enabled = YES;
}

-(void)disableScrubber
{
    self.scrubber.enabled = NO;
}
- (void)dealloc
{
    [self removePlayerTimeObserver];
    
    [self.player removeObserver:self forKeyPath:@"rate"];
    [_player.currentItem removeObserver:self forKeyPath:@"status"];
    
    [self.player pause];
    
    
}

@end

@implementation XYNewPlayer (Player)

#pragma mark Player Item

- (BOOL)isPlaying
{
    return mRestoreAfterScrubbingRate != 0.f || [self.player rate] != 0.f;
}

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    seekToZeroBeforePlay = YES;
}

- (CMTime)playerItemDuration
{
    AVPlayerItem *playerItem = [self.player currentItem];
    if (playerItem.status == AVPlayerItemStatusReadyToPlay)
    {
        return([playerItem duration]);
    }
    
    return(kCMTimeInvalid);
}
-(void)removePlayerTimeObserver
{
    if (mTimeObserver)
    {
        [self.player removeTimeObserver:mTimeObserver];
        mTimeObserver = nil;
    }
}


#pragma mark Error Handling

-(void)assetFailedToPrepareForPlayback:(NSError *)error
{
    [self removePlayerTimeObserver];
    [self syncScrubber];
    [self disableScrubber];
    [self disablePlayerButtons];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                        message:[error localizedFailureReason]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}


#pragma mark Prepare to play asset, URL
- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys
{
    for (NSString *thisKey in requestedKeys)
    {
        NSError *error = nil;
        AVKeyValueStatus keyStatus = [asset statusOfValueForKey:thisKey error:&error];
        if (keyStatus == AVKeyValueStatusFailed)
        {
            [self assetFailedToPrepareForPlayback:error];
            return;
        }
    }
    if (!asset.playable)
    {
        NSString *localizedDescription = NSLocalizedString(@"Item cannot be played", @"Item cannot be played description");
        NSString *localizedFailureReason = NSLocalizedString(@"The assets tracks were loaded, but could not be made playable.", @"Item cannot be played failure reason");
        NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   localizedDescription, NSLocalizedDescriptionKey,
                                   localizedFailureReason, NSLocalizedFailureReasonErrorKey,
                                   nil];
        NSError *assetCannotBePlayedError = [NSError errorWithDomain:@"StitchedStreaplayer" code:0 userInfo:errorDict];
        [self assetFailedToPrepareForPlayback:assetCannotBePlayedError];
        
        return;
    }
    if (self.playerItem)
    {
        [self.playerItem removeObserver:self forKeyPath:@"status"];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:self.playerItem];
    }
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    [self.playerItem addObserver:self
                       forKeyPath:@"status"
                          options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                          context:AVPlayerDemoPlaybackViewControllerStatusObservationContext];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.playerItem];
    
    seekToZeroBeforePlay = NO;
    if (!self.player)
    {
        [self setPlayer:[AVPlayer playerWithPlayerItem:self.playerItem]];
        [self.player addObserver:self
                      forKeyPath:@"currentItem"
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext];
        [self.player addObserver:self
                      forKeyPath:@"rate"
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:AVPlayerDemoPlaybackViewControllerRateObservationContext];
    }
    if (self.player.currentItem != self.playerItem)
    {
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
        
        [self syncPlayPauseButtons];
    }
    
    [self.scrubber setValue:0.0];
}

#pragma mark Asset Key Value Observing

- (void)observeValueForKeyPath:(NSString*) path
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context
{
    if (context == AVPlayerDemoPlaybackViewControllerStatusObservationContext)
    {
        [self syncPlayPauseButtons];
        
        AVPlayerItemStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status)
        {
            case AVPlayerItemStatusUnknown:
            {
                [self removePlayerTimeObserver];
                [self syncScrubber];
                
                [self disableScrubber];
                [self disablePlayerButtons];
            }
                break;
                
            case AVPlayerItemStatusReadyToPlay:
            {
                [self initScrubberTimer];
                
                [self enableScrubber];
                [self enablePlayerButtons];
                [self.player play];
            }
                break;
                
            case AVPlayerItemStatusFailed:
            {
                AVPlayerItem *playerItem = (AVPlayerItem *)object;
                [self assetFailedToPrepareForPlayback:playerItem.error];
            }
                break;
        }
    }
    else if (context == AVPlayerDemoPlaybackViewControllerRateObservationContext)
    {
        [self syncPlayPauseButtons];
    }
    else if (context == AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext)
    {
        AVPlayerItem *newPlayerItem = [change objectForKey:NSKeyValueChangeNewKey];
        if (newPlayerItem == (id)[NSNull null])
        {
            [self disablePlayerButtons];
            [self disableScrubber];
        }
        else
        {
            [self.playbackView setPlayer:_player];
            [self.playbackView setVideoFillMode:AVLayerVideoGravityResizeAspect];
            
            [self syncPlayPauseButtons];
        }
    }
    else
    {
        [super observeValueForKeyPath:path ofObject:object change:change context:context];
    }
}

@end
@implementation PlayBackView

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (AVPlayer*)player
{
    return [(AVPlayerLayer*)[self layer] player];
}

- (void)setPlayer:(AVPlayer*)player
{
    [(AVPlayerLayer*)[self layer] setPlayer:player];
}
- (void)setVideoFillMode:(NSString *)fillMode
{
    AVPlayerLayer *playerLayer = (AVPlayerLayer*)[self layer];
    playerLayer.videoGravity = fillMode;
}

@end
//在editschme中添加环境变量后打印出的寄存器信息多了AudioCodecs`ACBaseCodec::GetPropertyInfo(unsigned long, unsigned long&, unsigned char&)，但不知道具体什么意思
//播放视频崩溃
//register read
//General Purpose Registers:
//eax = 0x7c749030
//ebx = 0x10b7955c  AudioCodecs`ACBaseCodec::GetPropertyInfo(unsigned long, unsigned long&, unsigned char&) + 14
//ecx = 0x02f2b488  libc++abi.dylib`typeinfo for long
//edx = 0x00000000
//edi = 0xbff78790
//esi = 0xbff7878f
//ebp = 0xbff78768
//esp = 0xbff7874c
//ss = 0x00000023
//eflags = 0x00000286
//eip = 0x02f24695  libc++abi.dylib`__cxa_throw
//cs = 0x0000001b
//ds = 0x00000023
//es = 0x00000023
//fs = 0x00000000
//gs = 0x0000000f
//＝＝＝＝＝
//libc++abi.dylib`__cxa_throw:
//
//->  0x2f24695 <+0>:   pushl  %ebp
//
//0x2f24696 <+1>:   movl   %esp, %ebp
//
//0x2f24698 <+3>:   pushl  %ebx
//
//0x2f24699 <+4>:   pushl  %edi
//
//0x2f2469a <+5>:   pushl  %esi
//
//0x2f2469b <+6>:   subl   $0xc, %esp
//
//0x2f2469e <+9>:   calll  0x2f246a3                 ; <+14>
//
//0x2f246a3 <+14>:  popl   %eax
//
//0x2f246a4 <+15>:  movl   %eax, -0x10(%ebp)
//
//0x2f246a7 <+18>:  movl   0x10(%ebp), %ebx
//
//0x2f246aa <+21>:  movl   0x8(%ebp), %edi
//
//0x2f246ad <+24>:  calll  0x2f24248                 ; __cxa_get_globals
//
//0x2f246b2 <+29>:  movl   %eax, %esi
//
//0x2f246b4 <+31>:  calll  0x2f24c80                 ; std::get_unexpected()
//
//0x2f246b9 <+36>:  movl   %eax, -0x48(%edi)
//
//0x2f246bc <+39>:  calll  0x2f24ccf                 ; std::get_terminate()
//
//0x2f246c1 <+44>:  movl   %eax, -0x44(%edi)
//
//0x2f246c4 <+47>:  movl   0xc(%ebp), %eax
//
//0x2f246c7 <+50>:  movl   %eax, -0x50(%edi)
//
//0x2f246ca <+53>:  movl   %ebx, -0x4c(%edi)
//
//0x2f246cd <+56>:  leal   -0x20(%edi), %ebx
//
//0x2f246d0 <+59>:  movl   $0x474e5543, -0x1c(%edi)
//
//0x2f246d7 <+66>:  movl   $0x432b2b00, -0x20(%edi)
//
//0x2f246de <+73>:  movl   $0x1, -0x24(%edi)
//
//0x2f246e5 <+80>:  incl   0x4(%esi)
//
//0x2f246e8 <+83>:  movl   -0x10(%ebp), %eax
//
//0x2f246eb <+86>:  leal   0x6c(%eax), %eax
//
//0x2f246f1 <+92>:  movl   %eax, -0x18(%edi)
//
//0x2f246f4 <+95>:  movl   %ebx, (%esp)
//
//0x2f246f7 <+98>:  calll  0x2f276d2                 ; symbol stub for: _Unwind_RaiseException
//
//0x2f246fc <+103>: movl   %ebx, (%esp)
//
//0x2f246ff <+106>: calll  0x2f24741                 ; __cxa_begin_catch
//
//0x2f24704 <+111>: movl   -0x44(%edi), %eax
//
//0x2f24707 <+114>: movl   %eax, (%esp)
//
//0x2f2470a <+117>: calll  0x2f24ce2                 ; std::__terminate(void (*)())


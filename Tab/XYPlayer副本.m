//
//  XYPlayer.m
//  Tab
//
//  Created by zouxue on 15/9/5.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//

#import "XYPlayer.h"
#import "XYProgressView.h"
#import <AVFoundation/AVFoundation.h>
#define bottomControlHeight 25
#define  observerTimeRange  @"loadedTimeRanges"
#define observerState       @"status"
@interface XYPlayer()
{
   
}
@property(nonatomic,strong)XYProgressView* progressView;// 缓冲进度条
@property(nonatomic,strong)UIButton* playOrPauseBtn;//播放暂停按钮
@property(nonatomic,strong)UISlider* slider;//当前播放进度
@property(nonatomic,strong)AVPlayer* player;//播放器，要以 AVPlayerLayer加在view的layer上
@property(nonatomic,strong)AVPlayerLayer*  avplayer;
@property(nonatomic,strong)AVPlayerItem* playerItem;//一个视频项
@property(nonatomic,strong)UILabel* timeLabel;//右侧显示时间label
@property(nonatomic,copy)NSString* videoURLString;//视频url地址
@property(nonatomic,strong) NSString* totalDuration;//总时间长度
@property(nonatomic,strong)id timeCallBackBlock;
@end
@implementation XYPlayer
-(instancetype)initWithFrame:(CGRect)frame andVideoURL:(NSString*)urlString
{
    if (self=[super initWithFrame:frame]) {
        self.videoURLString=urlString;
        [self initControl];
        [self initPlayer];
    }
    return self;
}
-(void)initControl
{
    _playOrPauseBtn=[[UIButton alloc]initWithFrame:CGRectMake(10,CGRectGetHeight(self.bounds)-bottomControlHeight , 35, bottomControlHeight)];
    [_playOrPauseBtn addTarget:self action:@selector(playBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_playOrPauseBtn setTitle:@"播放" forState:UIControlStateNormal];
    _playOrPauseBtn.titleLabel.font=[UIFont systemFontOfSize:11];
     [self addSubview:_playOrPauseBtn];
    
    _progressView=[[XYProgressView alloc]initWithFrame:CGRectMake(38, CGRectGetHeight(self.bounds)-bottomControlHeight/2, CGRectGetWidth(self.bounds)-115, bottomControlHeight) andStyle:XYProgressViewStyleLine];
    _progressView.lineWidth=2;
    _progressView.tintColor=[[UIColor blueColor] colorWithAlphaComponent:0.8];
    
    _slider=[[UISlider alloc]initWithFrame:CGRectMake(38, CGRectGetHeight(self.bounds)-bottomControlHeight, CGRectGetWidth(self.bounds)-115, bottomControlHeight)];
    
    _timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_progressView.frame), CGRectGetHeight(self.bounds)-bottomControlHeight, CGRectGetWidth(self.bounds)-CGRectGetMaxX(_progressView.frame), bottomControlHeight)];
    _timeLabel.font=[UIFont systemFontOfSize:11];
    [self addSubview:_progressView];
    [self addSubview:_timeLabel];
    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_slider addTarget:self action:@selector(slierValueChangeEnd:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_slider];
    _slider.enabled=NO;
    _playOrPauseBtn.enabled=NO;
    self.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.5];
}
-(void)play
{
    if (_player) {
        AVPlayerItem* playItem=[_player currentItem];
        if (playItem.status==AVPlayerItemStatusReadyToPlay) {
            [_player play];
        }
    }
}
-(void)pause
{
    if (_player) {
        AVPlayerItem* playItem=[_player currentItem];
        if (playItem.status==AVPlayerItemStatusReadyToPlay) {
            [_player pause];
        }
    }
}
-(void)replacePlayerItemWithVideoURLString:(NSString*)otherVideoURLString
{
    
    if (![self.videoURLString isEqualToString:otherVideoURLString]||(self.videoURLString==nil)) {
        AVPlayerItem*otherItem=[self playerItemWithURLString:otherVideoURLString];
        [self replaceItem:otherItem];
        self.videoURLString=[NSString stringWithFormat:@"%@",otherVideoURLString];
    }

}
-(AVPlayerItem*)playerItemWithURLString:(NSString*)urlString
{
    NSURL * url=[NSURL URLWithString:urlString];
      AVPlayerItem* otherItem=[AVPlayerItem playerItemWithURL:url];
    return otherItem;
}
-(void)replaceItem:(AVPlayerItem*)otherPlayerItem
{
    if (self.playerItem) {
        [self removeObserverAndNotification];
        self.playerItem=otherPlayerItem;
        [self registerCurrentPlayerItemObserverAndNotification];
        [self.player replaceCurrentItemWithPlayerItem:otherPlayerItem];
    }
    else
    {
        self.playerItem=otherPlayerItem;
        [self initPlayer];
    }
}
-(void)registerCurrentPlayerItemObserverAndNotification
{
    if (self.playerItem) {
    [self.playerItem addObserver:self forKeyPath:observerState options:NSKeyValueObservingOptionNew context:nil];//监听状态，可以获得视频总时长等信息
    [self.playerItem addObserver:self forKeyPath:observerTimeRange options:NSKeyValueObservingOptionNew context:nil];//监听这个可以得到缓冲时间
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinish:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    }
}
-(void)removeObserverAndNotification
{
    if (self.playerItem) {
    [self.playerItem removeObserver:self forKeyPath:observerState];
    [self.playerItem removeObserver:self forKeyPath:observerTimeRange];
    [self.player removeTimeObserver:self.timeCallBackBlock];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemTimeJumpedNotification object:self.playerItem];
    }
}
-(void)initPlayer
{
   
    _playerItem=[self playerItemWithURLString:_videoURLString];
    CGRect frame=self.bounds;
    frame.size.height-=bottomControlHeight;
    [self registerCurrentPlayerItemObserverAndNotification];
    _player = [AVPlayer playerWithPlayerItem:self.playerItem];
    _avplayer=[AVPlayerLayer playerLayerWithPlayer:self.player];
    _avplayer.frame=frame;
    [self.layer addSublayer:_avplayer];
    
}
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    AVPlayerItem *playerItem = (AVPlayerItem *)object;
//    if ([keyPath isEqualToString:@"status"]) {
//        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
//            NSLog(@"AVPlayerStatusReadyToPlay");
//            self.playOrPauseBtn.enabled = YES;
//            [_player play];
//            CMTime duration = self.playerItem.duration;// 获取视频总长度
//            CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;// 转换成秒
//            [self timeStringWithFloatValue:totalSecond];// 转换成播放时间
//            [self setSliderMaxValue:100];// 自定义UISlider外观
//            NSLog(@"movie total duration:%f",CMTimeGetSeconds(duration));
//            [self addCallBackBlockWithPlayItem:self.playerItem];// 监听播放状态
//        } else if ([playerItem status] == AVPlayerStatusFailed) {
//            NSLog(@"AVPlayerStatusFailed");
//        }
//    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
//        NSTimeInterval timeInterval = [self  getTimeBuffer];// 计算缓冲进度
//        NSLog(@"Time Interval:%f",timeInterval);
//        CMTime duration = _playerItem.duration;
//        CGFloat totalDuration = CMTimeGetSeconds(duration);
//        [self.progressView setProgress:timeInterval / totalDuration];
//    }
//}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    AVPlayerItem* playItem=(AVPlayerItem*)object;
    if ([keyPath isEqualToString:observerState]) {
        if (playItem.status==AVPlayerItemStatusReadyToPlay) {
            _slider.enabled=YES;
            [_player play];
            _playOrPauseBtn.enabled=YES;
            [_playOrPauseBtn setTitle:@"暂停" forState:UIControlStateNormal];
            NSLog(@"AVPlayerItemStatusReadyToPlay");
            CGFloat durationFloatValue=CMTimeGetSeconds(playItem.duration);
            [self setSliderMaxValue:durationFloatValue];//设置滑块的最大值
            self.totalDuration=[self timeStringWithFloatValue:durationFloatValue];//设置总时间
            
            [self addCallBackBlockWithPlayItem:self.playerItem];
        }
        else if (playItem.status==AVPlayerItemStatusFailed)
        {
             NSLog(@"视频读取失败");
        }
    }else if ([keyPath isEqualToString:observerTimeRange]) {
        CGFloat buffer=[self getTimeBuffer];
        CGFloat total=CMTimeGetSeconds(self.playerItem.duration);
        [self.progressView setProgress:buffer/total];
    }
    else{
        
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(NSTimeInterval)getTimeBuffer
{
    AVPlayerItem * playItem=[self.player currentItem];
        NSArray* loadedTimeRanges=[playItem loadedTimeRanges];
    CMTimeRange timeRange=[[loadedTimeRanges firstObject] CMTimeRangeValue];
    float start=CMTimeGetSeconds(timeRange.start);
    float durantion=CMTimeGetSeconds(timeRange.duration);
    return start+durantion;
    

}
-(void)addCallBackBlockWithPlayItem:(AVPlayerItem*)playItem
{
    
    //添加周期性调用的回调方法，参数1是时间间隔，一个是时间值，一个是scale。参数二：队列，传null就是主队咧。。如果传并行concurrent队列，apple说有意想不到的后果。。参数三就是调用的block了；
     //使用addPeriodicTimeObserverForInterval应注意的几点：
     //1用户要持有这个返回值，一直到注销掉为止
     //2注册和注销要成对出现，，否则apple说有意想不到的后果。。。
     //3时间间隔不应太短，看方法介绍说是如果你设的太短了，调用频率可能会低于你设定的值
    __weak typeof(self) weakSelf=self;//先转成weak。避免循环引用，再转乘strong，避免每次使用时注册自动释放池
    self.timeCallBackBlock=[self.player  addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time){
        __strong typeof(weakSelf) strongSelf=weakSelf;
        CGFloat currentTime=CMTimeGetSeconds(playItem.currentTime) ;
        [strongSelf.slider setValue:currentTime animated:YES];
        NSString* curTimeString=[strongSelf timeStringWithFloatValue:currentTime];
        strongSelf.timeLabel.text=[NSString stringWithFormat:@"%@/%@",curTimeString,strongSelf.totalDuration];
    }];
}
-(void)setSliderMaxValue:(CGFloat)time
{
    self.slider.maximumValue=time;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, 1), NO, 0);
    UIImage* markImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.slider setMaximumTrackImage:markImage forState:UIControlStateNormal];
    [self.slider setMinimumTrackImage:markImage forState:UIControlStateNormal];
}
-(void)playFinish:(NSNotification*)notification
{
    __weak typeof(self) weakSelf=self;
    [self.player seekToTime:kCMTimeZero completionHandler:^(BOOL finish){
        [weakSelf.player play];
        [weakSelf.slider setValue:0 animated:YES];
    }];
}
-(void)playBtnClicked:(UIButton*)sender
{
    if ([sender.titleLabel.text isEqualToString:@"播放"]) {
       [self.player play];
        [sender setTitle:@"暂停" forState:UIControlStateNormal];
    } else if ([sender.titleLabel.text isEqualToString:@"暂停"]) {
        [self.player pause];
        [sender setTitle:@"播放" forState:UIControlStateNormal];
    }
}
-(void)sliderValueChanged:(UISlider*)sender
{
    __weak typeof(self) weakSelf=self;
    [self.player seekToTime:CMTimeMake(sender.value, 1) completionHandler:^(BOOL finish){
        [weakSelf.player play];
    }];
    
}
-(void)slierValueChangeEnd:(UISlider*)sender
{
    __weak typeof(self) weakSelf=self;
    [self.player seekToTime:CMTimeMake(sender.value, 1) completionHandler:^(BOOL finish){
        [weakSelf.player play];
        [self.playOrPauseBtn setTitle:@"暂停" forState:UIControlStateNormal];
    }];

}
-(NSString*)timeStringWithFloatValue:(CGFloat)value
{
    NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
    if (value>60*60) {
        [formatter setDateFormat:@"HH:mm:ss"];
    }
    else
    {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSDate * date=[NSDate dateWithTimeIntervalSince1970:value];
    return [formatter stringFromDate:date];
}
-(void)dealloc
{
    [self removeObserverAndNotification];
//    [self.playerItem removeObserver:self forKeyPath:observerState context:nil];
//    [self.playerItem removeObserver:self forKeyPath:observerTimeRange context:nil];
//    [self.player removeTimeObserver:self.timeCallBackBlock];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
}
@end
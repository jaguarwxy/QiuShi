//
//  ContentListCell.m
//  Tab
//
//  Created by zouxue on 15/8/1.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//
#import "ContentListCell.h"
#import "ContentModal.h"
@implementation ContentListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _portrait=[UIImageView new];
        _portrait.image=[UIImage imageNamed:@"defultPortrit"];
        _portrait.userInteractionEnabled=YES;
         [self.contentView addSubview:_portrait];
       
        _name=[UILabel new];
        _name.textColor=[UIColor orangeColor];
        _name.font=[UIFont systemFontOfSize:16];
        _name.numberOfLines=0;
        [self.contentView addSubview:_name];
        
        _contentText=[UILabel new];
        _contentText.numberOfLines=0;
        _contentText.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:_contentText];
        
        _laughNumber=[UILabel new];
        _laughNumber.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:_laughNumber];
         _contentImage=[UIImageView new];
        [self.contentView addSubview:_contentImage];
        
        _cry=[UIButton buttonWithType:UIButtonTypeCustom];
        _smile=[UIButton buttonWithType:UIButtonTypeCustom];;
        _comment=[UIButton buttonWithType:UIButtonTypeCustom];
        _smile.tag=1;
        _cry.tag=2;
        _comment.tag=3;
        [self.contentView addSubview:_cry];
        [self.contentView addSubview:_smile];
        [self.contentView addSubview:_comment];
        
    }
    return self;
}
-(CGFloat)resizeFrame:(detailItemData*)modal
{
    CGFloat sum=46;
    UIFont* font=[UIFont systemFontOfSize:14];
    _portrait.frame=CGRectMake(25, 5, 35, 35);
    _name.frame=CGRectMake(65, 5, 240, 40);
    _contentText.frame=CGRectMake(20, 55, 280, 50);
    CGSize size =[modal.content boundingRectWithSize:CGSizeMake(280, 400) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    _contentText.text=modal.content;
    _contentText.frame=CGRectMake(MIN(25, (CGRectGetWidth(self.bounds)-290)/2), 55, 290, size.height);
    _contentImage.frame=CGRectMake((deviceWidth-modal.pictureSize.width)/2, CGRectGetMaxY(_contentText.frame)+10, modal.pictureSize.width,modal.pictureSize.height);
    _contentImage.backgroundColor=[[UIColor orangeColor] colorWithAlphaComponent:0.4];
    CGRect videoFrame=CGRectMake((self.bounds.size.width-310)/2,CGRectGetMaxY(_contentText.frame)+10 , 310, 340);
    if ( modal.high_url!=nil) {
        if(!_playerView)
        {   _playerView=[[XYPlayer alloc]initWithFrame:videoFrame andVideoURL:modal.high_url];
            [self addSubview:_playerView];
        }
        else
        {
            _playerView.hidden=NO;
        }
        
    }
    else if(_playerView)
    {
        
        _playerView.hidden=YES;
    }
    _laughNumber.frame=CGRectMake(30,self.bounds.size.height-60, 160, 20);
    CGRect frame=CGRectMake(30,self.bounds.size.height-33, 27, 27);
    _smile.frame=frame;
    frame.origin.x+=60;
    frame.size=CGSizeMake(27, 27);
    _cry.frame=frame;
    frame.origin.x+=60;
    frame.size=CGSizeMake(27, 27);
    _comment.frame=frame;
    sum+=60;
    return sum;
}
-(void)setLikeAndCommentLabelWithLikeNumber:(NSInteger )like andComment:(NSInteger)comment
{
    NSString *laugh=[NSString stringWithFormat:@"%lu 好笑－%lu评论",(unsigned long )like,(unsigned long )comment];
    self.laughNumber.text=laugh;
}
-(void)fillTheContent:(detailItemData*)modal
{
    [self resizeFrame:modal];
    self.name.text=[NSString stringWithFormat:@"%@",modal.userData.login];
    if (modal.userData.login.length==0) {
        self.name.text=@"匿名";
    }
    self.contentText.text=modal.content;
    NSString *laugh=[NSString stringWithFormat:@"%@ 好笑－%lu评论",modal.up,(unsigned long)modal.comments_count];
    _numberLike=[modal.up integerValue];
    _numberComment=modal.comments_count;
    [self setLikeAndCommentLabelWithLikeNumber:_numberLike andComment:_numberComment];
    self.laughNumber.text=laugh;
    if(modal.selectType==1)
    {
        [_smile setBackgroundImage:[UIImage imageNamed:@"like2Selected"] forState:UIControlStateNormal];
        [_cry setBackgroundImage:[UIImage imageNamed:@"unlike2"] forState:UIControlStateNormal];
        _smile.userInteractionEnabled=NO;
        _cry.userInteractionEnabled=YES;
    }
    else if(modal.selectType==2)
    {
        [_smile setBackgroundImage:[UIImage imageNamed:@"like2"] forState:UIControlStateNormal];
        [_cry setBackgroundImage:[UIImage imageNamed:@"unlike2Selected"] forState:UIControlStateNormal];
        _smile.userInteractionEnabled=YES;
        _cry.userInteractionEnabled=NO;
    }
    else
    {
        [_cry setBackgroundImage:[UIImage imageNamed:@"unlike2"] forState:UIControlStateNormal];
        [_smile setBackgroundImage:[UIImage imageNamed:@"like2"] forState:UIControlStateNormal];
        _smile.userInteractionEnabled=YES;
        _cry.userInteractionEnabled=YES;
    }
     [_comment setBackgroundImage:[UIImage imageNamed:@"commentButton1"] forState:UIControlStateNormal];
}
-(void)setCellImageWithModal:(detailItemData*)modal
{
    NSString* portritURLString=[[XYHelper shareHelper] portritURLStringWithUserID:modal.userData.userID andPicName:modal.userData.icon ];
    if (portritURLString!=nil&&![portritURLString isEqualToString:@""]&&!modal.userData.userIcon) {
        [self.portrait sd_setImageWithURL:[NSURL URLWithString:portritURLString] placeholderImage:[UIImage imageNamed:@"defultPortrit"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self setCirclePortrit:image];
            modal.userData.userIcon=image;
            //            UIImage* userIcon=[self getCircleImage:image];//cg画的原型头像，但是效果不是很好，，毛躁
            //            cell.portrait.image=userIcon;
            //            modal.userData.userIcon=userIcon;
        }];
    }
    else  if(modal.userData.userIcon)
    {
        [self setCirclePortrit:modal.userData.userIcon];
    }
    else
    {
        self.portrait.image=[UIImage imageNamed:@"defultPortrit"];
    }
    ///NSLog(@"portritURLString:%@",portritURLString);
    //正文图片设置
    NSString* contentURLString=[[XYHelper shareHelper] contentImageURLStringWithPicName:modal.image];
    if (contentURLString!=nil&&contentURLString.length>0&&!modal.contentImage) {
        [self.contentImage sd_setImageWithURL:[NSURL URLWithString:contentURLString] placeholderImage:[UIImage imageNamed:@"defultPortrit"]];
        
        [self.contentImage sd_setImageWithURL:[NSURL URLWithString:contentURLString] placeholderImage:[UIImage imageNamed:@"defultPortrit"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            self.contentImage.image=image;
            modal.contentImage=image;
        }];
        
    }
    else if(modal.contentImage)
    {
        self.contentImage.image=modal.contentImage;
    }
    else
    {
        self.contentImage.image=[UIImage imageNamed:@"defultPortrit"];
    }
    
}
-(void)removePlayer
{
    [self.playerView pause];
    [self.playerView removeFromSuperview];
    self.playerView=nil;
}
//这个是直接在矩形图片上画，，效果好些，cg画处理有毛躁感
-(void)setCirclePortrit:(UIImage*)image
{
    //但是这样会强制离屏渲染，改天用clip处理下
    _portrait.image=image;
    [_portrait.layer setCornerRadius:CGRectGetHeight(_portrait.bounds)/2];
    _portrait.layer.masksToBounds=YES;
    _portrait.layer.borderWidth=5;
    _portrait.layer.borderColor=[[UIColor clearColor] CGColor];
}
@end

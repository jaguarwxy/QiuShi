//
//  myCommentCell.m
//  Tab
//
//  Created by zouxue on 15/8/23.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//

#import "CommentCell.h"
#import "ContentModal.h"
@implementation CommentCell

- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _portrait=[UIImageView new];
        _name=[UILabel new];
        _floor=[UILabel new];
        _content=[UILabel new];
        _portrait.userInteractionEnabled=YES;
        _name.numberOfLines=0;
        _content.numberOfLines=0;
        _name.font=[UIFont systemFontOfSize:16];
        _content.font=[UIFont systemFontOfSize:14];
        _name.textColor=[UIColor orangeColor];
        _floor.font=[UIFont systemFontOfSize:10];
        [self addSubview:_portrait];
        [self addSubview:_name];
        [self addSubview:_floor];
        [self addSubview:_content];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(CGFloat)resizeFrame:(commentDetail*)modal
{
    CGFloat sum=65;
    UIFont* font=[UIFont systemFontOfSize:14];
    _portrait.frame=CGRectMake(20, 5, 35, 35);
    _name.frame=CGRectMake(60, 10, 240, 20);
    _content.frame=CGRectMake(20, 40, 220, 50);
    CGSize size = [modal.content boundingRectWithSize:CGSizeMake(220, 400) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
   // _content.text=modal.content;
    _content.frame=CGRectMake(60, CGRectGetMaxY(_name.frame)+5, 220, size.height);
    sum+=size.height;
    _floor.frame=CGRectMake(280, CGRectGetMidY(_name.frame)-8, 25, 25);
   // _floor.backgroundColor=[UIColor redColor];
    return sum;
}
-(void)fillTheContent:(commentDetail*)modal
{
    [self resizeFrame:modal];
    _name.text=modal.userData.login;
    if (modal.userData.login.length==0) {
        _name.text=@"匿名";
    }
    _portrait.image=[UIImage imageNamed:@"defultPortrit"];
    _content.text=modal.content;
    //NSLog(@"%@",modal.floor);
   ///  _floor.text=modal.floor就一直出错，属性写的是nsstring啊？奇怪，没把nsnumber转换成nsstring吗？   -[__NSCFNumber rangeOfCharacterFromSet:]: unrecognized selector sent to instance
    _floor.text=[NSString stringWithFormat:@"%@",modal.floor ];
    //NSLog(@"%@",NSStringFromClass([modal.floor class]));草，还真是 __NSCFNumber,还延迟执行 我日
    switch ([modal.floor integerValue]) {
        case 1:
            _floor.text=@"沙发";
            break;
            
        case 2:
            _floor.text=@"板凳";
            break;
        case 3:
            _floor.text=@"地板";
            break;
    }
}

-(void)PortraitImageInComentCell:(commentDetail*)modal
{
    NSString* portritURLString=[[XYHelper shareHelper] portritURLStringWithUserID:modal.userData.userID andPicName:modal.userData.icon];
    if(modal.userData.userIcon)
    {
        [self setCirclePortrit:modal.userData.userIcon];
    }
    else if(portritURLString!=nil&&![portritURLString isEqualToString:@""]&&!modal.userData.userIcon) {
        [self.portrait sd_setImageWithURL:[NSURL URLWithString:portritURLString] placeholderImage:[UIImage imageNamed:@"defultPortrit"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self setCirclePortrit:image];
            modal.userData.userIcon=image;
        }];
    }
    else
    {
        self.portrait.image=[UIImage imageNamed:@"defultPortrit"];
    }
    
}

-(void)setCirclePortrit:(UIImage*)image
{
    _portrait.image=image;
    [_portrait.layer setCornerRadius:CGRectGetHeight(_portrait.bounds)/2];
    _portrait.layer.masksToBounds=YES;
    _portrait.layer.borderWidth=5;
    _portrait.layer.borderColor=[[UIColor clearColor] CGColor];
}
@end

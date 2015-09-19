//
//  XYDiscoverTableViewCell.m
//  Tab
//
//  Created by zouxue on 15/9/17.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//

#import "XYDiscoverTableViewCell.h"

@implementation XYDiscoverTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _icon=[UIImageView new];
        _subTitle=[UILabel new];
        _title=[UILabel new];
        _title.font=[UIFont systemFontOfSize:16];
        _subTitle.font=[UIFont systemFontOfSize:11];
        [self addSubview:_icon];
        [self addSubview:_subTitle];
        [self addSubview:_title];
    }
    return self;
}
-(void)resizeFrameWithData:(NSDictionary*)dic
{
    self.title.text=dic[@"title"];
     self.subTitle.text=dic[@"subTitle"];
    CGSize  titleSize=[self.title.text boundingRectWithSize:CGSizeMake(300, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    CGSize subTitleSize=[self.subTitle.text boundingRectWithSize:CGSizeMake(300, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    
    CGRect titleFrame=CGRectMake(70,( CGRectGetHeight(self.bounds)-titleSize.height-subTitleSize.height-20)/2, titleSize.width, titleSize.height);
    self.title.frame=titleFrame;
    CGRect subTitleFrame=CGRectMake(70, CGRectGetMaxY(_title.frame)+20, subTitleSize.width, subTitleSize.height);
   
    self.subTitle.frame=subTitleFrame;
    NSArray* picSize=dic[@"pic_size"];
    CGFloat width=[[picSize firstObject] floatValue];
    CGFloat height=[[picSize lastObject] floatValue];
    CGFloat picX=(70-width)/2;
    CGFloat picY=(CGRectGetHeight(self.bounds)-height)/2;
    CGRect picFrame=CGRectMake(picX, picY, width, height);
    self.icon.frame=picFrame;
    self.icon.image=[UIImage imageNamed:dic[@"icon"]];
    
    
}
-(void)fillTheContent:(NSDictionary*)dic
{
    [self resizeFrameWithData:dic];
}

@end

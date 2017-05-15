//
//  VTableViewCell.m
//  JimmyCacheData
//
//  Created by Lenwave on 2017/5/15.
//  Copyright © 2017年 jimmy. All rights reserved.
//

#import "VTableViewCell.h"
#import "UIImageView+WebCache.h"


@interface VTableViewCell ()

/** 注释 */
@property(strong,nonatomic) UIImageView * iconImageV;
/** 注释 */
@property(strong,nonatomic) UILabel * titleLb;

/** 注释 */
@property(strong,nonatomic) UILabel * connectLb;

@end


@implementation VTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    
    return self;
}



- (void)setUI
{
    self.iconImageV = [[UIImageView alloc] initWithFrame:CGRectMake(16, 10, 80, 80)];
    [self addSubview:self.iconImageV];
    
    self.titleLb = [[UILabel alloc] initWithFrame:CGRectMake(106, 30, 180, 20)];
    [self addSubview:self.titleLb];
    
    self.connectLb = [[UILabel alloc] initWithFrame:CGRectMake(106, 60, 180, 20)];
    [self addSubview:self.connectLb];
    
}



-(void)setModel:(DataModel *)model
{
    _model = model;
    
    self.titleLb.text = model.intro;
    self.connectLb.text = model.tags;
    
    [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:model.coverLarge] placeholderImage:nil];
}







- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

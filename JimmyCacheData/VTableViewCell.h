//
//  VTableViewCell.h
//  JimmyCacheData
//
//  Created by Lenwave on 2017/5/15.
//  Copyright © 2017年 jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@interface VTableViewCell : UITableViewCell

/** 注释 */
@property(strong,nonatomic) DataModel * model;

@end

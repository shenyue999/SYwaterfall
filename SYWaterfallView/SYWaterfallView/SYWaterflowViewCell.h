//
//  SYWaterflowViewCell.h
//  UIScollView循环利用
//
//  Created by 申岳 on 16/9/2.
//  Copyright © 2016年 shenyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYWaterflowViewCellDelegate <NSObject>

-(void)cellClickindex:(NSInteger)index;

@end

@interface SYWaterflowViewCell : UIView
@property(nonatomic,copy,readonly)NSString *identifier;
-(instancetype)initWithidentifier:(NSString *)identifier;
@property(nonatomic,weak) id<SYWaterflowViewCellDelegate> delegate;

@end

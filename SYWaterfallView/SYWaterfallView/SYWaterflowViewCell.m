//
//  SYWaterflowViewCell.m
//  UIScollView循环利用
//
//  Created by 申岳 on 16/9/2.
//  Copyright © 2016年 shenyue. All rights reserved.
//

#import "SYWaterflowViewCell.h"

@implementation SYWaterflowViewCell
-(void)tapClick{
    if ([self.delegate respondsToSelector:@selector(cellClickindex:)]) {
        [self.delegate cellClickindex:self.tag];
    }
}
-(instancetype)initWithidentifier:(NSString *)identifier{
    if (self = [super init]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
        [self addGestureRecognizer:tap];
        _identifier = identifier;
    }
    return self;
}
@end

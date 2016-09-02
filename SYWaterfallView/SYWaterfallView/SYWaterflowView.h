//
//  SYWaterflowView.h
//  UIScollView循环利用
//
//  Created by 申岳 on 16/9/2.
//  Copyright © 2016年 shenyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYWaterflowViewCell,SYWaterflowView;

@protocol SYWaterflowViewDataSource <NSObject>
//要求强制实现
@required
-(NSUInteger)numberOfCellsInWaterflowView:(SYWaterflowView *)waterflowView;

-(SYWaterflowViewCell *)waterflowView:(SYWaterflowView *)waterflowView cellAtIndex:(NSUInteger)index;
//不要求强制实现
@optional
-(NSUInteger)numberOfColumnsInWaterflowView:(SYWaterflowView *)waterflowView;
@end

@protocol SYWaterflowViewDelegate <NSObject>

//不要求强制实现
@optional
-(CGFloat)waterflowView:(SYWaterflowView *)waterflowView heightAtIndex:(NSUInteger)index;

-(void)waterflowView:(SYWaterflowView *)waterflowView didSelectAtIndex:(NSUInteger)index;

-(UIEdgeInsets)waterflowView:(SYWaterflowView *)waterflowView;
@end

@interface SYWaterflowView : UIScrollView

@property(nonatomic,weak) id<SYWaterflowViewDataSource> dataSource;

@property(nonatomic,weak) id<SYWaterflowViewDelegate> Waterflowdelegate;

#pragma mark-公共方法

-(void)reloadData;

- (id)dequeueReusableCellWithIdentifier:(NSString*)identifier;
@end

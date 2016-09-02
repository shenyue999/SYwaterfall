//
//  ViewController.m
//  UIScollView循环利用
//
//  Created by 申岳 on 16/9/2.
//  Copyright © 2016年 shenyue. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate,SYWaterflowViewDelegate,SYWaterflowViewDataSource>

@property(nonatomic,strong) SYWaterflowView *WaterflowView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SYWaterflowView *waterflow=[[SYWaterflowView alloc]init];
    waterflow.frame=self.view.bounds;
    waterflow.Waterflowdelegate = self;
    waterflow.dataSource = self;
    _WaterflowView = waterflow;
    [self.view addSubview:waterflow];
    
    //刷新数据
    [_WaterflowView reloadData];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(NSUInteger)numberOfCellsInWaterflowView:(SYWaterflowView*)waterflowView
{
    return 300;
}
-(NSUInteger)numberOfColumnsInWaterflowView:(SYWaterflowView*)waterflowView
{
    return 5;
}
-(SYWaterflowViewCell *)waterflowView:(SYWaterflowView*)waterflowView cellAtIndex:(NSUInteger)index
{
    static NSString *ID= @"cell" ;
    UILabel  *lb = nil;
    SYWaterflowViewCell *cell=[waterflowView dequeueReusableCellWithIdentifier:ID];
    
    lb = [cell viewWithTag:-1];
    if (lb != nil) {
        lb.text = [NSString stringWithFormat:@"%zd",index];
        [lb sizeToFit];
        
    }
    if(cell == nil) {
        cell=[[SYWaterflowViewCell alloc] initWithidentifier:ID];
        //给cell设置一个随机色
        cell.backgroundColor=[UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
        lb = [[UILabel alloc]init];
        lb.text = [NSString stringWithFormat:@"%zd",index];
        lb.textColor = [UIColor blackColor];
        lb.tag = -1;
        [lb sizeToFit];
        [cell addSubview:lb];
    }
    return cell;
}
#pragma mark-代理方法
-(CGFloat)waterflowView:(SYWaterflowView *)waterflowView heightAtIndex:(NSUInteger)index
{
    return 50 + arc4random_uniform(100);
}

-(UIEdgeInsets)waterflowView:(SYWaterflowView *)waterflowView{
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
-(void)waterflowView:(SYWaterflowView *)waterflowView didSelectAtIndex:(NSUInteger)index
{
    NSLog(@"点击了%zd位置的cell" ,index);
}
@end

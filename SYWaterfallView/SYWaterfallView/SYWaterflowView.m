//
//  SYWaterflowView.m
//  UIScollView循环利用
//
//  Created by 申岳 on 16/9/2.
//  Copyright © 2016年 shenyue. All rights reserved.
//

#import "SYWaterflowView.h"
#import "SYWaterflowViewCell.h"
#import <Foundation/Foundation.h>
#define SYWaterflowViewDefaultNumberOfClunms 3
#define SYWaterflowViewDefaultCellH  100

static const UIEdgeInsets SYWaterflowViewDefaultEdgeInsets = {10,10,10,10};

@interface SYWaterflowView ()<SYWaterflowViewCellDelegate>
@property(nonatomic,strong)NSMutableArray *cellFrames;

@property(nonatomic,strong)NSMutableDictionary *displayingCells;

@property(nonatomic,strong)NSMutableSet *reusableCells;

@property(nonatomic,strong) NSMutableArray *ColumnsHeight;
@end

@implementation SYWaterflowView

#pragma mark-懒加载
-(NSMutableArray *)cellFrames
{
    if(_cellFrames==nil) {
        _cellFrames=[NSMutableArray array];
    }
    return _cellFrames;
}

-(NSMutableDictionary *)displayingCells
{
    if(_displayingCells==nil) {
        _displayingCells=[NSMutableDictionary dictionary];
    }
    return _displayingCells;
}

-(NSMutableSet *)reusableCells
{
    if(_reusableCells==nil) {
        _reusableCells=[NSMutableSet set];
    }
    return _reusableCells;
}

- (NSMutableArray *)ColumnsHeight {
    if(_ColumnsHeight == nil) {
        _ColumnsHeight = [NSMutableArray array];
    }
    return _ColumnsHeight;
}
- (id)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self){
    }
    return self;
}
#pragma mark-私有方法
-(BOOL)isInScreen:(CGRect)frame{
    return(CGRectGetMaxY(frame) > self.contentOffset.y) &&
    (CGRectGetMinY(frame) < self.contentOffset.y + self.frame.size.height);
    
}
-(NSUInteger)numberOfColumns{
    if([self.dataSource respondsToSelector:@selector(numberOfColumnsInWaterflowView:)]){
        return [self.dataSource numberOfColumnsInWaterflowView:self];
    }else
    {
        return SYWaterflowViewDefaultNumberOfClunms;
    }
}
-(CGFloat)heightAtIndex:(NSUInteger)index
{
    if([self.Waterflowdelegate respondsToSelector:@selector(waterflowView:heightAtIndex:)]){
        return [self.Waterflowdelegate waterflowView:self heightAtIndex:index];
    }else
    {
        return SYWaterflowViewDefaultCellH;
    }
}
-(UIEdgeInsets)marginForType
{
    if([self.Waterflowdelegate respondsToSelector:@selector(waterflowView:)]){
        return  [self.Waterflowdelegate waterflowView:self];
    }else
    {
        return SYWaterflowViewDefaultEdgeInsets;
    }
}
#pragma mark - 代理方法
-(id)dequeueReusableCellWithIdentifier:(NSString*)identifier
{
    __block SYWaterflowViewCell *reusableCell = nil;
    [self.reusableCells enumerateObjectsUsingBlock:^(SYWaterflowViewCell *cell, BOOL *stop){
        if ([cell.identifier isEqualToString:identifier]) {
            reusableCell=cell;
            *stop = YES;
        }
    }];
    if(reusableCell) {//从缓存池中移除（已经用掉了）
        [self.reusableCells removeObject:reusableCell];
    }
    return reusableCell;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //向数据源索要对应位置的cell
    NSUInteger numberOfCells = self.cellFrames.count;
    
    for (NSUInteger i = 0; i < numberOfCells; i++){
         //取出i位置的frame,注意转换
         CGRect cellFrame=[self.cellFrames[i] CGRectValue];

         //优先从字典中取出i位置的cell
         SYWaterflowViewCell *cell=self.displayingCells[@(i)];
         
         //判断i位置对应的frame在不在屏幕上（能否看见）
         if ([self isInScreen:cellFrame]) {//在屏幕上
             if (cell==nil) {
                 cell= [self.dataSource waterflowView:self cellAtIndex:i];
                 cell.frame=cellFrame;
                 cell.delegate = self;
                 cell.tag = i;
                 [self addSubview:cell];
                 //存放在字典中
                 self.displayingCells[@(i)]=cell;
             }
         }else //不在屏幕上
         {
             if (cell) {
                 //从scrollView和字典中删除
                 [cell removeFromSuperview];
                 [self.displayingCells removeObjectForKey:@(i)];
                 //存放进缓存池
                 [self.reusableCells addObject:cell];
             }
         }
         }
   
}
-(void)reloadData{
    //cell的总数是多少
    NSUInteger numberOfCells = [self.dataSource numberOfCellsInWaterflowView:self];
    //cell的列数
    NSUInteger numberOfColumns = [self numberOfColumns];
    //间距
    UIEdgeInsets EdgeInset= [self marginForType];
    CGFloat leftM = EdgeInset.left;
    CGFloat rightM =EdgeInset.right;
    CGFloat columnM =EdgeInset.left;
    CGFloat topM = EdgeInset.top;
    CGFloat rowM = EdgeInset.bottom;
    CGFloat bottomM = EdgeInset.bottom;
    //cell的宽度
    //cell的宽度=（整个view的宽度-左边的间距-右边的间距-（ 列数 - 1 ）X 每列之间的间距）/ 总列数
    CGFloat cellW = (self.frame.size.width- leftM - rightM - (numberOfColumns - 1) * columnM) / numberOfColumns;
    
    [self.ColumnsHeight removeAllObjects];
    
    for (NSUInteger i = 0; i < numberOfCells; i++){
        [self.ColumnsHeight addObject:@(topM)];
        }
         //计算每个cell的fram
    for (NSUInteger i = 0; i < numberOfCells; i++){
        //cell处在第几列（最短的一列）
        __block  NSUInteger cellAtColumn = 0;
        //cell所处那列的最大的Y值（当前最短的那一列的最大的Y值）
        //默认设置最短的一列为第一列（优化性能）
        __block CGFloat minOfCellAtColumnH = [self.ColumnsHeight[0] doubleValue];
        
        for (int i = 0; i < numberOfColumns; i++) {
            
            CGFloat ColumnHeight = [self.ColumnsHeight[i] doubleValue];
            
            if (ColumnHeight < minOfCellAtColumnH){
                
                minOfCellAtColumnH = ColumnHeight;
                
                cellAtColumn = i;
            }
        }
            //（3）cell的位置（X,Y）
            //cell的X=左边的间距+列号*（cell的宽度+每列之间的间距）
              CGFloat cellX = leftM + cellAtColumn * (cellW + columnM);
            //cell的Y，先设定为0
              CGFloat cellY=0;
              if (minOfCellAtColumnH == 0.0) {//首行
                  
                           cellY = topM;
                  
                       }else{
                           
                           cellY = minOfCellAtColumnH + rowM;
                       }
                       //设置cell的frame并添加到数组中
                       CGRect cellFrame=CGRectMake(cellX, cellY, cellW, [self heightAtIndex:i]);
        
                       [self.cellFrames addObject:[NSValue valueWithCGRect:cellFrame]];
                   //更新最短那一列的最大的Y值
                     self.ColumnsHeight[cellAtColumn] =@(CGRectGetMaxY(cellFrame));
        
//                       //显示cell
//                        SYWaterflowViewCell *cell=[self.dataSource waterflowView:self cellAtIndex:i];
//        
//                        cell.delegate = self;
//        
//                        cell.frame = cellFrame;
//        
//                        [self addSubview:cell];
        
                    }

           //设置contentSize
           CGFloat contentH = [self.ColumnsHeight[0] doubleValue];
    
           for (int i = 1; i < numberOfCells;i++){

                if ([self.ColumnsHeight[i] doubleValue]>contentH) {
                    
                    contentH = [self.ColumnsHeight[i] doubleValue];
                    }
               }
              contentH += bottomM;
              self.contentSize = CGSizeMake(0, contentH);
}
                            
#pragma mark -SYWaterflowViewCellDelegate
-(void)cellClickindex:(NSInteger)index{
    if ([self.Waterflowdelegate respondsToSelector:@selector(waterflowView:didSelectAtIndex:)]) {
        [self.Waterflowdelegate waterflowView:self didSelectAtIndex:index];
    }
}

@end


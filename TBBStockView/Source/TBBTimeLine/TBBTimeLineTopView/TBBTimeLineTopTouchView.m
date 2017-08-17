
//
//  TBBTouchView.m
//  TBB-Kline
//
//  Created by 唐彬彬 on 2017/7/3.
//  Copyright © 2017年 唐彬彬. All rights reserved.
//  手势view

#import "TBBTimeLineTopTouchView.h"
#import "Common.h"
#import "Masonry.h"
#import "UIColor+HL.h"
#import "TBBTimeLineTopView.h"
#import "TBBTimeLineTopModel.h"
#import "TBBTimeLineTopPointModel.h"
#import "TBBTimeLineBottomPointModel.h"

@interface TBBTimeLineTopTouchView ()
@property (nonatomic, strong) CAShapeLayer *topViewXLayer;//横线
@property (nonatomic, strong) CAShapeLayer *topViewYLayer;//竖线
@property (nonatomic, strong) CAShapeLayer *bottomViewXLayer;//横线
@property (nonatomic, strong) CAShapeLayer *bottomViewYLayer;//竖线
@property (nonatomic, assign) NSInteger curentModelIndex;
@property (nonatomic, strong) UIImageView     *pointView;//点图标
/**
 *  在topView x坐标上蓝色滑动label
 */
@property (nonatomic, strong) UILabel         *pointVictLabel;

/**
 *  在topView y坐标上的蓝色滑动label,显示实际数值
 */
@property (nonatomic, strong) UILabel         *pointHoriLabel;

/**
 *  在topView y坐标上的蓝色滑动label,显示百分比
 */
@property (nonatomic, strong) UILabel         *pointHoriPercentLabel;
/**
 *  在bottomView y坐标上的滑动label,显示成交量数值
 */
@property (nonatomic, strong) UILabel         *volumeLabel;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@end

@implementation TBBTimeLineTopTouchView

-(CAShapeLayer *)topViewXLayer {
    if (!_topViewXLayer) {
        _topViewXLayer = [CAShapeLayer layer];
        _topViewXLayer.lineWidth = 0.5f;
        _topViewXLayer.strokeColor = [UIColor colorWithHexString:@"FFB90F"].CGColor;
        [self.layer addSublayer:_topViewXLayer];
    }
    return _topViewXLayer;
}
-(CAShapeLayer *)topViewYLayer {
    if (!_topViewYLayer) {
        _topViewYLayer = [CAShapeLayer layer];
        _topViewYLayer.lineWidth = 0.5f;
        _topViewYLayer.strokeColor = [UIColor colorWithHexString:@"FFB90F"].CGColor;
        [self.layer addSublayer:_topViewYLayer];
    }
    return _topViewYLayer;
}
-(CAShapeLayer *)bottomViewXLayer {
    if (!_bottomViewXLayer) {
        _bottomViewXLayer = [CAShapeLayer layer];
        _bottomViewXLayer.lineWidth = 0.5f;
        _bottomViewXLayer.strokeColor = [UIColor colorWithHexString:@"1860FE"].CGColor;
        [self.layer addSublayer:_bottomViewXLayer];
    }
    return _bottomViewXLayer;
}
-(CAShapeLayer *)bottomViewYLayer {
    if (!_bottomViewYLayer) {
        _bottomViewYLayer = [CAShapeLayer layer];
        _bottomViewYLayer.lineWidth = 0.5f;
        _bottomViewYLayer.strokeColor = [UIColor colorWithHexString:@"1860FE"].CGColor;
        [self.layer addSublayer:_bottomViewYLayer];
    }
    return _bottomViewYLayer;
}
-(UIImageView *)pointView{
    if (!_pointView) {
        NSString * bundlePath = [[NSBundle mainBundle] pathForResource: @"images"ofType :@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        NSString *img_path = [resourceBundle pathForResource:@"dian_@2x" ofType:@"png"];
        _pointView = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:img_path]];
        [self addSubview:_pointView];
        [_pointView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(8.f);
            make.height.mas_equalTo(8.f);
        }];
    }
    return _pointView;
}

/**
 显示topView上横坐标的label
 
 @return label
 */
-(UILabel *)pointVictLabel{
    if (!_pointVictLabel) {
        _pointVictLabel = [[UILabel alloc]init];
        _pointVictLabel.textColor = [UIColor blackColor];
        _pointVictLabel.font = [UIFont boldSystemFontOfSize:10.f];
        _pointVictLabel.textAlignment = NSTextAlignmentCenter;
        _pointVictLabel.backgroundColor = [UIColor colorWithHexString:@"FFB90F"];
        [self addSubview:_pointVictLabel];
    }
    return _pointVictLabel;
}
/**
 显示topView上纵坐标的label

 @return label
 */
-(UILabel *)pointHoriLabel{
    if (!_pointHoriLabel) {
        _pointHoriLabel = [[UILabel alloc]init];
        _pointHoriLabel.textColor = [UIColor blackColor];
        _pointHoriLabel.font = [UIFont boldSystemFontOfSize:10.f];
        _pointHoriLabel.textAlignment = NSTextAlignmentCenter;
        _pointHoriLabel.backgroundColor = [UIColor colorWithHexString:@"FFB90F"];
        [self addSubview:_pointHoriLabel];
    }
    return _pointHoriLabel;
}
/**
 显示topView上纵坐标的百分比label
 
 @return label
 */
-(UILabel *)pointHoriPercentLabel{
    if (!_pointHoriPercentLabel) {
        _pointHoriPercentLabel = [[UILabel alloc]init];
        _pointHoriPercentLabel.textColor = [UIColor blackColor];
        _pointHoriPercentLabel.font = [UIFont boldSystemFontOfSize:10.f];
        _pointHoriPercentLabel.textAlignment = NSTextAlignmentCenter;
        _pointHoriPercentLabel.backgroundColor = [UIColor colorWithHexString:@"FFB90F"];
        [self addSubview:_pointHoriPercentLabel];
    }
    return _pointHoriPercentLabel;
}
-(UILabel *)volumeLabel {

    if (!_volumeLabel) {
        _volumeLabel = [[UILabel alloc]init];
        _volumeLabel = [[UILabel alloc]init];
        _volumeLabel.textColor = [UIColor blackColor];
        _volumeLabel.font = [UIFont boldSystemFontOfSize:10.f];
        _volumeLabel.textAlignment = NSTextAlignmentCenter;
        _volumeLabel.backgroundColor = [UIColor colorWithHexString:@"FFB90F"];
        [self addSubview:_volumeLabel];
    }
    return _volumeLabel;
}
- (instancetype)initWithFrame:(CGRect)frame withTopViewPointArray:(NSArray *)topViewPointArray BottomViewPointArray:(NSArray *)bottomViewPointArray {

    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        if (!_topViewPointArray) {
            _topViewPointArray = [NSArray arrayWithArray:topViewPointArray];
            
        }
        if (!_bottomViewPointArray) {
            _bottomViewPointArray = [NSArray arrayWithArray:bottomViewPointArray];
        }
        self.longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesture:)];
        [self addGestureRecognizer:self.longPressGesture];
    }
    return self;

}

#pragma mark UILongPressGestureRecognizer   长按手势
- (void)longPressGesture:(UILongPressGestureRecognizer *)longPress {
    if (UIGestureRecognizerStateChanged == longPress.state || UIGestureRecognizerStateBegan == longPress.state) {
        CGPoint location = [longPress locationInView:self];
        //获取手势位置计算，选取最近的数据里的坐标点
        if (self.topViewPointArray.count <= 0) {
            return;
        }else {
        
            CGPoint topViewPoint = [self getLongPressModelPostionWithTopView:location.x];
            //        NSLog(@"%f,%f",topViewPoint.x,bottomViewPoint.y);
            //绘制topView上的十字光标线
            UIBezierPath *topViewXPath = [UIBezierPath bezierPath];
            UIBezierPath *topViewYPath = [UIBezierPath bezierPath];
            [topViewXPath moveToPoint:CGPointMake(topViewPoint.x, kHeightMargin)];
            [topViewXPath addLineToPoint:CGPointMake(topViewPoint.x, kTimeLineTopViewHeight-kHeightMargin-kSlideHeigth)];
            [topViewYPath moveToPoint:CGPointMake(kWidthMargin, topViewPoint.y)];
            [topViewYPath addLineToPoint:CGPointMake(kCurrentPhoneWidth-kWidthMargin, topViewPoint.y)];
            self.topViewXLayer.path = topViewXPath.CGPath;
            self.topViewYLayer.path = topViewYPath.CGPath;
            //交叉点的位置
            self.pointView.hidden = NO;
            self.pointHoriLabel.hidden = NO;
            self.pointVictLabel.hidden = NO;
            self.pointHoriPercentLabel.hidden = NO;
            self.pointView.layer.cornerRadius = self.pointView.frame.size.width*0.5;
            self.pointView.layer.masksToBounds= YES;
            self.pointView.center = CGPointMake(topViewPoint.x, topViewPoint.y);
            //获取到模型数据,准备赋值
            if (self.dataArray && self.dataArray != nil) {
                TBBTimeLineTopModel *model = self.dataArray[self.curentModelIndex];
                [self addSlideViewWhenMovedWithModel:model topViewPoint:topViewPoint];
            }else {
                
                return;
            }
        }
        
        if (self.bottomViewPointArray.count <= 0) {
            return;
        }else {
            CGPoint bottomViewPoint = [self getLongPressModelPostionWithBottomView:location.x];
            //        NSLog(@"%f,%f",topViewPoint.x,bottomViewPoint.y);
            //绘制bottomView上的十字光标线
            UIBezierPath *bottomViewXPath = [UIBezierPath bezierPath];
            UIBezierPath *bottomViewYPath = [UIBezierPath bezierPath];
            [bottomViewXPath moveToPoint:CGPointMake(bottomViewPoint.x, kTimeLineTopViewHeight)];
            [bottomViewXPath addLineToPoint:CGPointMake(bottomViewPoint.x, kTimeLineTopViewHeight+kTimeLineBottomViewHeight-kHeightMargin)];
            [bottomViewYPath moveToPoint:CGPointMake(kWidthMargin, bottomViewPoint.y+kTimeLineTopViewHeight)];
            [bottomViewYPath addLineToPoint:CGPointMake(kCurrentPhoneWidth-kWidthMargin, bottomViewPoint.y+kTimeLineTopViewHeight)];
            self.bottomViewXLayer.path = bottomViewXPath.CGPath;
            self.bottomViewYLayer.path = bottomViewYPath.CGPath;
            self.volumeLabel.hidden = NO;
           // 获取到模型数据,准备赋值
            if (self.dataArray && self.dataArray != nil) {
                TBBTimeLineTopModel *model = self.dataArray[self.curentModelIndex];
                [self addSlideViewWhenMovedWithModel:model bottomViewPoint:bottomViewPoint];
            }else {
                
                return;
            }
        }

    }
    
    if(longPress.state == UIGestureRecognizerStateEnded)
    {
        self.topViewXLayer.path = nil;
        self.topViewYLayer.path = nil;
        self.bottomViewXLayer.path = nil;
        self.bottomViewYLayer.path = nil;
        //如果设置pointview = nil 每次手指移开的时候pointview都会停留在最后的位置不会消失
        self.pointView.hidden = YES;
        self.pointHoriLabel.hidden = YES;
        self.pointVictLabel.hidden = YES;
        self.pointHoriPercentLabel.hidden = YES;
        self.volumeLabel.hidden = YES;
    }
    
    
}

#pragma mark 长按获取坐标

/**
 长安获取TopView上的坐标

 @param xPostion 当前手势x点坐标
 @return 返回模型里面点坐标
 */
-(CGPoint)getLongPressModelPostionWithTopView:(CGFloat)xPostion
{
    if (self.topViewPointArray.count > 0) {
        
        for (NSInteger i = 0; i<self.topViewPointArray.count; i++) {
            TBBTimeLineTopPointModel *model = self.topViewPointArray[i];
            if (i+1 < self.topViewPointArray.count) {
                TBBTimeLineTopPointModel *nextPointModel = self.topViewPointArray[i+1];
                if (xPostion >= model.xPosition && xPostion < nextPointModel.xPosition)
                {
                    if (fabs(xPostion-model.xPosition)<fabs(xPostion-nextPointModel.xPosition)) {
                        _curentModelIndex = i;
                        return CGPointMake(model.xPosition , model.yPosition);
                    }else{
                        _curentModelIndex = i+1;
                        return CGPointMake(nextPointModel.xPosition , nextPointModel.yPosition);
                    }
                }
            }
        }
        
        TBBTimeLineTopPointModel *lastPoint = self.topViewPointArray.lastObject;
        if (xPostion >= lastPoint.xPosition)
        {
            _curentModelIndex = self.topViewPointArray.count - 1;
            return CGPointMake(lastPoint.xPosition, lastPoint.yPosition);
        }
        TBBTimeLineTopPointModel *firstPoint = self.topViewPointArray.firstObject;
        if (xPostion <= firstPoint.xPosition)
        {
            _curentModelIndex = 0;
            return CGPointMake(firstPoint.xPosition, firstPoint.yPosition);
        }
    }
    
    
    return CGPointZero;
}

/**
 长安获取BottomView上的坐标
 
 @param xPostion 当前手势x点坐标
 @return 返回模型里面点坐标
 */
-(CGPoint)getLongPressModelPostionWithBottomView:(CGFloat)xPostion {

    if (self.bottomViewPointArray.count>0) {
        for (NSInteger i = 0; i<self.bottomViewPointArray.count; i++) {
            TBBTimeLineBottomPointModel *model = self.bottomViewPointArray[i];
            if (i+1 < self.topViewPointArray.count) {
                TBBTimeLineBottomPointModel *nextPointModel = self.bottomViewPointArray[i+1];
                if (xPostion >= model.xPosition && xPostion < nextPointModel.xPosition)
                {
                    if (fabs(xPostion-model.xPosition)<fabs(xPostion-nextPointModel.xPosition)) {
                        _curentModelIndex = i;
                        return CGPointMake(model.xPosition , model.yPosition);
                    }else{
                        _curentModelIndex = i+1;
                        return CGPointMake(nextPointModel.xPosition , nextPointModel.yPosition);
                    }
                }
            }
        }
        
        TBBTimeLineBottomPointModel *lastPoint = self.bottomViewPointArray.lastObject;
        if (xPostion >= lastPoint.xPosition)
        {
            _curentModelIndex = self.bottomViewPointArray.count - 1;
            return CGPointMake(lastPoint.xPosition, lastPoint.yPosition);
        }
        TBBTimeLineBottomPointModel *firstPoint = self.bottomViewPointArray.firstObject;
        if (xPostion <= firstPoint.xPosition)
        {
            _curentModelIndex = 0;
            return CGPointMake(firstPoint.xPosition, firstPoint.yPosition);
        }
    }

    return CGPointZero;

}
/**
 *  添加topView上的滑块
 *
 *  @param model 实时数据模型
 */
-(void)addSlideViewWhenMovedWithModel:(TBBTimeLineTopModel*)model topViewPoint:(CGPoint)point{
    CGFloat xMinPosition = point.x - kSlideWidth/2;
    CGFloat yMinPosition = point.y - kSlideHeigth/2;
    CGFloat xMaxPosition = point.x + kSlideWidth/2;
    CGFloat yMaxPosition = point.y + kSlideHeigth/2;
    //显示纵坐标的view,显示点数
    self.pointHoriLabel.text = [NSString stringWithFormat:@"%.2f",model.lastPirce];
    //显示纵坐标的view,显示百分比
    self.pointHoriPercentLabel.text = [NSString stringWithFormat:@"%.2f%%",(-(model.preClosePx - model.lastPirce))/model.preClosePx *100];
    //添加横坐标的view,显示时间
    self.pointVictLabel.text = [NSString stringWithFormat:@"%@",model.currtTime];
    
    if (xMinPosition <= kWidthMargin) {
        self.pointVictLabel.frame = CGRectMake(kWidthMargin,kTimeLineTopViewHeight-kHeightMargin-kSlideHeigth, kSlideWidth, kSlideHeigth);
    }else if (xMaxPosition >= kCurrentPhoneWidth - kWidthMargin){
        self.pointVictLabel.frame = CGRectMake(kCurrentPhoneWidth - kWidthMargin-kSlideWidth, kTimeLineTopViewHeight-kSlideHeigth, kSlideWidth, kSlideHeigth);
    }else{
        self.pointVictLabel.frame = CGRectMake(xMinPosition,kTimeLineTopViewHeight-kHeightMargin-kSlideHeigth, kSlideWidth, kSlideHeigth);
    }
    if (yMinPosition <= kHeightMargin) {
        self.pointHoriLabel.frame = CGRectMake(kWidthMargin, kHeightMargin, kSlideWidth, kSlideHeigth);
         self.pointHoriPercentLabel.frame = CGRectMake(self.frame.size.width - kSlideWidth-kWidthMargin, kHeightMargin, kSlideWidth, kSlideHeigth);
    }else if (yMaxPosition >= (kTimeLineTopViewHeight-kHeightMargin)){
        self.pointHoriLabel.frame = CGRectMake(kWidthMargin, kTimeLineTopViewHeight-kHeightMargin-kSlideHeigth, kSlideWidth, kSlideHeigth);
        self.pointHoriPercentLabel.frame = CGRectMake(self.frame.size.width - kSlideWidth-kWidthMargin, kTimeLineTopViewHeight-kHeightMargin-kSlideHeigth, kSlideWidth, kSlideHeigth);
    }else{
    
        self.pointHoriLabel.frame = CGRectMake(kWidthMargin, yMinPosition, kSlideWidth, kSlideHeigth);
        self.pointHoriPercentLabel.frame = CGRectMake(self.frame.size.width - kSlideWidth-kWidthMargin, yMinPosition, kSlideWidth, kSlideHeigth);
    }
}

-(void)addSlideViewWhenMovedWithModel:(TBBTimeLineTopModel*)model bottomViewPoint:(CGPoint)point {
    /**
     从bottomView点坐标数组获取的点的frame是相对于bottomView的，在这里touchView用于显示的时候需要将点坐标转换成相对于touchView的点坐标，横坐标一致，纵坐标相应的增加了topView高度
     */
    CGFloat yMinPosition = point.y+kTimeLineTopViewHeight - kSlideHeigth/2;
    NSLog(@"yMinPosition-------------%.2f",yMinPosition);
    CGFloat yMaxPosition = point.y+kTimeLineTopViewHeight + kSlideHeigth/2;
    //显示纵坐标的view,显示点数
    self.volumeLabel.text = [NSString stringWithFormat:@"%.f",model.volume];
  
    if (yMinPosition <= kTimeLineTopViewHeight) {
        self.volumeLabel.frame = CGRectMake(kWidthMargin, kTimeLineTopViewHeight, kSlideWidth, kSlideHeigth);
    }else if (yMaxPosition >= (kTimeLineTopViewHeight+kTimeLineBottomViewHeight-kHeightMargin)){
        self.volumeLabel.frame = CGRectMake(kWidthMargin, kTimeLineTopViewHeight+kTimeLineBottomViewHeight-kHeightMargin-kSlideHeigth, kSlideWidth, kSlideHeigth);
        
    }else{
        self.volumeLabel.frame = CGRectMake(kWidthMargin, yMinPosition, kSlideWidth, kSlideHeigth);
       
    }

    
}
@end

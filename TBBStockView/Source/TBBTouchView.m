
//
//  TBBTouchView.m
//  TBB-Kline
//
//  Created by 唐彬彬 on 2017/7/3.
//  Copyright © 2017年 唐彬彬. All rights reserved.
//  手势view

#import "TBBTouchView.h"
#import "Common.h"
#import "Masonry.h"
#import "UIColor+HL.h"
#import "TBBTimeLineTopView.h"
#import "TBBTimeLineModel.h"
#import "TBBTimeLinePointModel.h"

#define kSlideWidth 40.f  //滑块宽度
#define kSlideHeigth 20.f  //滑块高度
#define kHeigthMargin 20.f  //离顶部间距
#define kWidthMargin 10.f  //离左边间距

@interface TBBTouchView ()
@property (nonatomic, strong) CAShapeLayer *xLayer;//横线
@property (nonatomic, strong) CAShapeLayer *yLayer;//竖线
@property (nonatomic, assign) NSInteger curentModelIndex;
@property (nonatomic, strong) UIImageView     *pointView;//点图标
/**
 *  在x坐标上蓝色滑动label
 */
@property (nonatomic, strong) UILabel         *pointVictLabel;

/**
 *  在y坐标上的蓝色滑动label,显示实际数值
 */
@property (nonatomic, strong) UILabel         *pointHoriLabel;

/**
 *  在y坐标上的蓝色滑动label,显示百分比
 */
@property (nonatomic, strong) UILabel         *pointHoriPercentLabel;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@end

@implementation TBBTouchView

-(CAShapeLayer *)xLayer {
    if (!_xLayer) {
        self.xLayer = [CAShapeLayer layer];
        self.xLayer.lineWidth = 0.5f;
        self.xLayer.strokeColor = [UIColor colorWithHexString:@"1860FE"].CGColor;
        [self.layer addSublayer:_xLayer];
    }
    return _xLayer;
}
-(CAShapeLayer *)yLayer {
    if (!_yLayer) {
        self.yLayer = [CAShapeLayer layer];
        self.yLayer.lineWidth = 0.5f;
        self.yLayer.strokeColor = [UIColor colorWithHexString:@"1860FE"].CGColor;
        [self.layer addSublayer:_yLayer];
    }
    return _yLayer;
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
-(UILabel *)pointHoriLabel{
    if (!_pointHoriLabel) {
        _pointHoriLabel = [[UILabel alloc]init];
        _pointHoriLabel.textColor = [UIColor blackColor];
        _pointHoriLabel.font = [UIFont boldSystemFontOfSize:10.f];
        _pointHoriLabel.textAlignment = NSTextAlignmentCenter;
        _pointHoriLabel.backgroundColor = [UIColor colorWithHexString:@"FFB90F"];
        [self addSubview:self.pointHoriLabel];
    }
    return _pointHoriLabel;
}
-(UILabel *)pointVictLabel{
    if (!_pointVictLabel) {
        _pointVictLabel = [[UILabel alloc]init];
        _pointVictLabel.textColor = [UIColor blackColor];
        _pointVictLabel.font = [UIFont boldSystemFontOfSize:10.f];
        _pointVictLabel.textAlignment = NSTextAlignmentCenter;
        _pointVictLabel.backgroundColor = [UIColor colorWithHexString:@"FFB90F"];
        [self addSubview:self.pointVictLabel];
    }
    return _pointVictLabel;
}
-(UILabel *)pointHoriPercentLabel{
    if (!_pointHoriPercentLabel) {
        _pointHoriPercentLabel = [[UILabel alloc]init];
        _pointHoriPercentLabel.textColor = [UIColor blackColor];
        _pointHoriPercentLabel.font = [UIFont boldSystemFontOfSize:10.f];
        _pointHoriPercentLabel.textAlignment = NSTextAlignmentCenter;
        _pointHoriPercentLabel.backgroundColor = [UIColor colorWithHexString:@"FFB90F"];
        [self addSubview:self.pointHoriPercentLabel];
    }
    return _pointHoriPercentLabel;
}

- (instancetype)initWithFrame:(CGRect)frame withPointArray:(NSArray *)pointArr{

    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        if (!_pointArray) {
            self.pointArray = [NSArray arrayWithArray:pointArr];
            
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
        if (self.pointArray.count <= 0) {
            return;
        }
        CGPoint point = [self getLongPressModelPostionWithXPostion:location.x];
        NSLog(@"%f,%f",point.x,point.y);
        //绘制十字光标线
        UIBezierPath *xPath = [UIBezierPath bezierPath];
        UIBezierPath *yPath = [UIBezierPath bezierPath];
        [xPath moveToPoint:CGPointMake(point.x, kHeigthMargin)];
        [xPath addLineToPoint:CGPointMake(point.x, 180.f)];
        [yPath moveToPoint:CGPointMake(kWidthMargin, point.y)];
        [yPath addLineToPoint:CGPointMake(kCurrentPhoneWidth-kWidthMargin, point.y)];
        self.xLayer.path = xPath.CGPath;
        self.yLayer.path = yPath.CGPath;
        //交叉点的位置
        self.pointView.hidden = NO;
        self.pointHoriLabel.hidden = NO;
        self.pointVictLabel.hidden = NO;
        self.pointHoriPercentLabel.hidden = NO;
        self.pointView.layer.cornerRadius = self.pointView.frame.size.width*0.5;
        self.pointView.layer.masksToBounds= YES;
        self.pointView.center = CGPointMake(point.x, point.y);
        //获取到模型数据,准备赋值
        if (self.dataArray && self.dataArray != nil) {
            TBBTimeLineModel *model = self.dataArray[self.curentModelIndex];
            [self addSlideViewWhenMovedWithModel:model andTmpK:point];
        }else {
        
            return;
        }
    }
    
    if(longPress.state == UIGestureRecognizerStateEnded)
    {
        self.xLayer.path = nil;
        self.yLayer.path = nil;
        //如果设置pointview = nil 每次手指移开的时候pointview都会停留在最后的位置不会消失
        self.pointView.hidden = YES;
        self.pointHoriLabel.hidden = YES;
        self.pointVictLabel.hidden = YES;
        self.pointHoriPercentLabel.hidden = YES;
    }
    
    
}

#pragma mark 长按获取坐标

-(CGPoint)getLongPressModelPostionWithXPostion:(CGFloat)xPostion
{
    if (self.pointArray.count > 0) {
        
        for (NSInteger i = 0; i<self.pointArray.count; i++) {
            TBBTimeLinePointModel *model = self.pointArray[i];
            if (i+1 < self.pointArray.count) {
                TBBTimeLinePointModel *nextPointModel = self.pointArray[i+1];
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
        
        TBBTimeLinePointModel *lastPoint = self.pointArray.lastObject;
        if (xPostion >= lastPoint.xPosition)
        {
            _curentModelIndex = self.pointArray.count - 1;
            return CGPointMake(lastPoint.xPosition, lastPoint.yPosition);
        }
        TBBTimeLinePointModel *firstPoint = self.pointArray.firstObject;
        if (xPostion <= firstPoint.xPosition)
        {
            _curentModelIndex = 0;
            return CGPointMake(firstPoint.xPosition, firstPoint.yPosition);
        }
    }
    
    return CGPointZero;
}

/**
 *  添加滑块
 *
 *  @param model 实时数据模型
 */
-(void)addSlideViewWhenMovedWithModel:(TBBTimeLineModel*)model andTmpK:(CGPoint)point{
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
        self.pointVictLabel.frame = CGRectMake(kWidthMargin,160.f, kSlideWidth, kSlideHeigth);
    }else if (xMaxPosition >= kCurrentPhoneWidth - kWidthMargin){
        self.pointVictLabel.frame = CGRectMake(kCurrentPhoneWidth - kWidthMargin-kSlideWidth, 160.f, kSlideWidth, kSlideHeigth);
    }else{
        self.pointVictLabel.frame = CGRectMake(xMinPosition,160.f, kSlideWidth, kSlideHeigth);
    }
    if (yMinPosition <= kHeigthMargin) {
        self.pointHoriLabel.frame = CGRectMake(kWidthMargin, kHeigthMargin, kSlideWidth, kSlideHeigth);
         self.pointHoriPercentLabel.frame = CGRectMake(self.frame.size.width - kSlideWidth-kWidthMargin, kHeigthMargin, kSlideWidth, kSlideHeigth);
    }else if (yMaxPosition >= 180.f){
        self.pointHoriLabel.frame = CGRectMake(kWidthMargin, 180.f-kSlideHeigth/2, kSlideWidth, kSlideHeigth);
        self.pointHoriPercentLabel.frame = CGRectMake(self.frame.size.width - kSlideWidth-kWidthMargin, 180.f-kSlideHeigth/2, kSlideWidth, kSlideHeigth);
    }else{
    
        self.pointHoriLabel.frame = CGRectMake(kWidthMargin, yMinPosition, kSlideWidth, kSlideHeigth);
        self.pointHoriPercentLabel.frame = CGRectMake(self.frame.size.width - kSlideWidth-kWidthMargin, yMinPosition, kSlideWidth, kSlideHeigth);
    }
}
@end

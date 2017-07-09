//
//  BtnView.h
//  SelectedBtn
//
//  Created by 唐彬彬 on 2017/3/28.
//  Copyright © 2017年 唐彬彬. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^addSubViewBlock)(NSInteger tag);
@interface BtnView : UIView
@property (nonatomic ,copy) addSubViewBlock myBlock;
-(instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray selectedColor:(UIColor *)selectedColor normalColor:(UIColor *)normalColor titleSize:(CGSize *)size;
-(void)addSubviewWithBlock:(addSubViewBlock)block;
@end

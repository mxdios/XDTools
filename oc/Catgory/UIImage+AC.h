//
//  UIImage+AC.h
//  airconditioner
//
//  Created by 苗晓东 on 15/7/9.
//  Copyright (c) 2015年 miaoxiaodong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AC)
/**
 *  拉伸图片
 */
+ (UIImage *)pullImage:(NSString *)imageName;

/**
 *  拉伸图片，可指定拉伸位置
 */
+ (UIImage *)pullImage:(NSString *)imageName leftRatio:(CGFloat)leftratio topRatio:(CGFloat)topratio;

/**
 *  等比缩放到指定大小
 */
+ (UIImage*)imageCompressImage:(NSString *)imageName Scale:(CGFloat)scale;

/** 染背景色*/
- (UIImage *)image:(UIImage *)image withColor:(UIColor *)color;
/** 染内容*/
- (UIImage *)imageContentWithColor:(UIColor *)color ;
/** 拼接图片*/
- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2;
@end

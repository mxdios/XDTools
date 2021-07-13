//
//  UIImage+AC.m
//  airconditioner
//
//  Created by 苗晓东 on 15/7/9.
//  Copyright (c) 2015年 miaoxiaodong. All rights reserved.
//

#import "UIImage+AC.h"

@implementation UIImage (AC)
+ (UIImage *)pullImage:(NSString *)imageName
{
    return [self pullImage:imageName leftRatio:0.5 topRatio:0.5];
}

+ (UIImage *)pullImage:(NSString *)imageName leftRatio:(CGFloat)leftratio topRatio:(CGFloat)topratio
{
    UIImage *pullImage = [UIImage imageNamed:imageName];
    CGFloat left = pullImage.size.width * leftratio;
    CGFloat top = pullImage.size.height * topratio;
    return [pullImage stretchableImageWithLeftCapWidth:left topCapHeight:top];
}

+ (UIImage*)imageCompressImage:(NSString *)imageName Scale:(CGFloat)scale
{
    UIImage *compressImage = [UIImage imageNamed:imageName];
    CGSize size = compressImage.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGFloat scaledWidth = width * scale;
    CGFloat scaledHeight = height * scale;
    UIGraphicsBeginImageContext(size); // this will crop
    [compressImage drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
    UIImage* newImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;

}
- (UIImage *)imageContentWithColor:(UIColor *)color {
    if (!color) {
        return nil;
    }
    
    UIImage *newImage = nil;
    
    CGRect imageRect = (CGRect){CGPointZero,self.size};
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, self.scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0.0, -(imageRect.size.height));
    
    CGContextClipToMask(context, imageRect, self.CGImage);//选中选区 获取不透明区域路径
    CGContextSetFillColorWithColor(context, color.CGColor);//设置颜色
    CGContextFillRect(context, imageRect);//绘制
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();//提取图片
    
    UIGraphicsEndImageContext();
    return newImage;
}
// 画背景
- (UIImage *)image:(UIImage *)image withColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [image drawInRect:rect];
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextFillRect(context, rect);
    
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// 合成图片
- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 {
    UIGraphicsBeginImageContext(image1.size);
    
    // Draw image2  哪个图片在最下面先画谁，在这里有先后顺序
    [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
    
    // Draw image1
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

// 画带有边框的圆，在画这个图片的时候用到了，也写出来吧，但是边框设的为零，
- (UIImage *)circleImageName:(NSString *)path borderWith:(double)border colorWith:(UIColor *)color
{
    UIImage *img=[UIImage imageNamed:path];
    UIGraphicsBeginImageContext(img.size );
    
    CGContextRef ctr =UIGraphicsGetCurrentContext();
    
    double radius=img.size.height>img.size.width?(img.size.width/2):(img.size.height/2);
    
    radius/=2;
    
    double centerx=img.size.width/2;
    double centery=img.size.height/2;
    
    [color set];
    //   CGContextSetLineWidth(ctr, border);
    CGContextAddArc(ctr, centerx, centery, radius+border,0, M_PI_2*4,YES);
    CGContextFillPath(ctr);
    
    CGContextAddArc(ctr, centerx, centery, radius,0, M_PI_2*4,YES);
    CGContextClip(ctr);
    
    [img drawInRect:CGRectMake(0,0, img.size.width, img.size.height)];
    
    UIImage *newImg=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImg;
    
}
@end

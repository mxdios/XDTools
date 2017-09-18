//
//  UIBarButtonItem+HX.m
//  hanxin
//
//  Created by inspiry on 15/11/20.
//  Copyright © 2015年 inspiry. All rights reserved.
//

#import "UIBarButtonItem+HX.h"

@implementation UIBarButtonItem (HX)
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    //    btn.backgroundColor  =randomColor;
    //    CGSize btnSize = btn.frame.size;
    //    btnSize = CGSizeMake(btn.currentBackgroundImage.size.width, btn.currentBackgroundImage.size.height);
    btn.frame = CGRectMake(0, 0, 30, 30);
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
+(UIBarButtonItem *)itemFixedSpace:(NSInteger)space
{
    UIBarButtonItem* negativeSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    /**
     *  如果是rightBarButtonItems:
     *  width为负数时，相当于btn向右移动width数值个像素(系统自带的按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整).
     *  默认为0；width为正数时，正好相反，相当于往左移动width数值个像素
     */
    
    /**
     *  如果是leftBarButtonItems:
     *  width为负数时，相当于btn向左移动width数值个像素(系统自带的按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整).
     *  默认为0；width为正数时，正好相反，相当于往右移动width数值个像素
     */
    negativeSpace.width = space;
    return negativeSpace;
}
@end

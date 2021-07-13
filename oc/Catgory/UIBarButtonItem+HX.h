//
//  UIBarButtonItem+HX.h
//  hanxin
//
//  Created by inspiry on 15/11/20.
//  Copyright © 2015年 inspiry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (HX)
/**
 *  导航栏左右按钮分类方法
 */
+ (instancetype) itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;
+(UIBarButtonItem *)itemFixedSpace:(NSInteger)space;
@end

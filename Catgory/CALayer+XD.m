//
//  CALayer+XD.m
//  paipaiaudit
//
//  Created by miaoxiaodong on 2017/5/23.
//  Copyright © 2017年 miaoxiaodong. All rights reserved.
//

#import "CALayer+XD.h"

@implementation CALayer (XD)
- (void)setBorderColorWithUIColor:(UIColor *)color {
    self.borderColor = color.CGColor;
}
@end

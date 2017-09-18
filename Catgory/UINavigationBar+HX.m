//
//  UINavigationBar+HX.m
//  hanxin
//
//  Created by inspiry on 15/11/20.
//  Copyright © 2015年 inspiry. All rights reserved.
//

#import "UINavigationBar+HX.h"
#import <objc/runtime.h>


@implementation UINavigationBar (HX)
static char overlayKey;
- (UIView *)overlay
{
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay
{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)hx_setBackgroundColor:(UIColor *)backgroundColor
{
    if (!self.overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self setShadowImage:[UIImage new]];        // insert an overlay into the view hierarchy
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 64)];
        [self insertSubview:self.overlay atIndex:0];
        self.overlay.userInteractionEnabled = NO;
    }
    self.overlay.backgroundColor = backgroundColor;
}
@end

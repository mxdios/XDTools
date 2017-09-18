//
//  UITextField+ExtentRange.h
//  gasstation
//
//  Created by inspiry on 16/5/11.
//  Copyright © 2016年 inspiry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (ExtentRange)
/**
 *  获取光标位置
 */
- (NSRange)selectedRange;
/**
 *  设置光标位置
 */
- (void)setSelectedRange:(NSRange) range;
@end

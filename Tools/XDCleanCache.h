//
//  XDCleanCache.h
//  insposapp
//
//  Created by miaoxiaodong on 2017/7/4.
//  Copyright © 2017年 miaoxiaodong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^cleanCacheBlock)();


@interface XDCleanCache : NSObject
/**
 *  清理缓存
 */
+(void)cleanCache:(cleanCacheBlock)block;
/**
 *  整个缓存目录的大小
 */
+(float)folderSizeAtPath;
@end

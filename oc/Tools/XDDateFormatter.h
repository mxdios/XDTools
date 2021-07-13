//
//  XDTools.h
//  ImageEdit
//
//  Created by miaoxiaodong on 2017/4/26.
//  Copyright © 2017年 markmiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    /// yyyy.MM.dd
    DateFormatterStringTypeYMDDot,
    /// yyyy-MM-dd
    DateFormatterStringTypeYMDLine,
    /// yyyy/MM/dd
    DateFormatterStringTypeYMDBias,
    /// yyyy.MM.dd HH:mm:ss
    DateFormatterStringTypeYMDHMSDot,
    /// yyyy-MM-dd HH:mm:ss
    DateFormatterStringTypeYMDHMSLine,
    /// yyyy/MM/dd HH:mm:ss
    DateFormatterStringTypeYMDHMSBias,
    /// MM.dd.yyyy
    DateFormatterStringTypeMDYDot,
    /// MM-dd-yyyy
    DateFormatterStringTypeMDYLine,
    /// MM/dd/yyyy
    DateFormatterStringTypeMDYBias,
    /// MM.dd.yyyy HH:mm:ss
    DateFormatterStringTypeMDYHMSDot,
    /// MM-dd-yyyy HH:mm:ss
    DateFormatterStringTypeMDYHMSLine,
    /// MM/dd/yyyy HH:mm:ss
    DateFormatterStringTypeMDYHMSBias,
} DateFormatterStringType;

@interface XDDateFormatter : NSObject

/// 获取月份有多少天
+ (NSInteger)getMonthDaysWithYear:(NSInteger)year Month:(NSInteger)month;
/// 获取本周第一天
+ (NSDate *)getThisWeekFirstDayWithDate:(NSDate *)date;
/// 获取本月第一天
+ (NSDate *)getThisMonthFirstDayWithDate:(NSDate *)date;
/// date返回日期选择
+ (NSDateComponents *)getDateComps:(NSDate *)date;
/// 根据date转换为年月, 区分中英文
+ (NSString *)getYearMonethInternational:(NSDate *)date;
/// 毫秒值转字符串时间
+ (NSString *)xd_TimestampToTime:(NSString *)time formatterType:(DateFormatterStringType)type;
/// date转字符串时间
+ (NSString *)xd_DateToTimeWith:(NSDate *)date formatterType:(DateFormatterStringType)type;
/// 字符串时间转date
+ (NSDate *)xd_TimeToDateWith:(NSString *)time formatterType:(DateFormatterStringType)type;
/// 字符串时间格式转换
+ (NSString *)xd_TimeFormatterChangeWith:(NSString *)time fromFormatter:(DateFormatterStringType)formType toFormatter:(DateFormatterStringType)toType;
/// 获取系统时区
+ (NSString *)getSytemTimeZone;

@end

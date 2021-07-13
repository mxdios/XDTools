//
//  XDDateFormatter.m
//  ImageEdit
//
//  Created by miaoxiaodong on 2017/4/26.
//  Copyright © 2017年 markmiao. All rights reserved.
//

#import "XDDateFormatter.h"

@implementation XDDateFormatter
+ (NSInteger)getMonthDaysWithYear:(NSInteger)year Month:(NSInteger)month {
    NSArray *daysArray = @[@0, @31, @28, @31, @30, @31, @30, @31, @31, @30, @31, @30, @31];
    if (2 == month && (year % 400 == 0 || (year % 100 != 0 && year % 4 == 0))) {
        return 29;
    }
    return [daysArray[month] integerValue];
}
+ (NSDate *)getThisWeekFirstDayWithDate:(NSDate *)date {
    NSDateComponents *components = [self getDateComps:date];//周日为第一天
    NSTimeInterval seconds = (components.weekday - 1) * 24 * 60 * 60 + components.hour * 60 * 60 + components.minute * 60 + components.second;//间隔秒数
    return [NSDate dateWithTimeInterval:-seconds sinceDate:date];//正数未来，负数过去
}
+ (NSDate *)getThisMonthFirstDayWithDate:(NSDate *)date {
    NSDateComponents *components = [self getDateComps:date];
    NSString *monthFirstTime;
    if ([self isCurrentLanguageEnglish]) {
       monthFirstTime = [NSString stringWithFormat:@"%ld-01-%ld 00:00:00", components.month, components.year];
    } else {
        monthFirstTime = [NSString stringWithFormat:@"%ld-%ld-01 00:00:00", components.year, components.month];
    }
    return [self xd_TimeToDateWith:monthFirstTime formatterType:DateFormatterStringTypeYMDHMSLine];
}
+ (NSDateComponents *)getDateComps:(NSDate *)date {
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
}
+ (NSString *)getYearMonethInternational:(NSDate *)date {
    NSDateComponents *component = [self getDateComps:date];
    if ([self isCurrentLanguageEnglish]) { //是英文环境
        NSArray *months = @[@"Jan.", @"Feb.", @"Mar.", @"Apr.", @"May", @"Jun.", @"Jul.", @"Aug.", @"Sep.", @"Oct.", @"Nov.", @"Dec."];
        return [NSString stringWithFormat:@"%@%ld", months[component.month - 1], component.year];
    } else {
        return [NSString stringWithFormat:@"%ld/%02ld", component.year, component.month];
    }
}

+ (NSString *)xd_TimestampToTime:(NSString *)time formatterType:(DateFormatterStringType)type {
    NSDate *date = [self xd_TimestampToDate:time];
    NSDateFormatter *formatter = [self xd_GetDateFormatterWithType:type];
    return [formatter stringFromDate:date];
}
+ (NSString *)xd_DateToTimeWith:(NSDate *)date formatterType:(DateFormatterStringType)type {
    NSDateFormatter *formatter = [self xd_GetDateFormatterWithType:type];
    return [formatter stringFromDate:date];
}
+ (NSDate *)xd_TimeToDateWith:(NSString *)time formatterType:(DateFormatterStringType)type {
    NSDateFormatter *formatter = [self xd_GetDateFormatterWithType:type];
    return [formatter dateFromString:time];
}
+ (NSString *)xd_TimeFormatterChangeWith:(NSString *)time fromFormatter:(DateFormatterStringType)formType toFormatter:(DateFormatterStringType)toType {
    NSDateFormatter *formFormatter = [self xd_GetDateFormatterWithType:formType];
    NSDate *date = [formFormatter dateFromString:time];
    NSDateFormatter *toFormatter = [self xd_GetDateFormatterWithType:toType];
    return [toFormatter stringFromDate:date];
}
+ (NSString *)getSytemTimeZone {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    return [NSString stringWithFormat:@"%ld000", zone.secondsFromGMT];
}
@end

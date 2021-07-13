//
//  XDTools.h
//  ImageEdit
//
//  Created by miaoxiaodong on 2017/4/26.
//  Copyright © 2017年 markmiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    UnreadNumAddOne,
    UnreadNumCutOne,
    UnreadNumClear,
} UnreadNum;

@interface XDTools : NSObject
/// 正则判断手机号
+(BOOL)isPhoneNum:(NSString *)string;
/// textview文字垂直居中
+ (void)contentSizeToFit:(UITextView *)textView;
/// 拷贝一个view
+ (UIView *)copyViewWith:(UIView *)view;
/// 是否存在某字体
+ (BOOL)isFontIsExist:(NSString *)fontName;
/// 判断两个颜色是否相等
+ (BOOL)isTheSameColor2:(UIColor*)color1 anotherColor:(UIColor*)color2;
/// 获取appDelegate
+ (AppDelegate *)getAppDelegate;
/// 时间戳转为当前时间字符串
+ (NSString *)getTimeWithIntervalSince:(NSString *)timeStr;
/// 获取月份有多少天
+ (NSInteger)getMonthDaysWithYear:(NSInteger)year Month:(NSInteger)month;
/// 根据date获取年-月-日时间
+ (NSString *)getNowTime2:(NSDate *)date;
/// 根据date获取年-月-日 时:分:秒完整时间字符串
+ (NSString *)getNowAllTime2:(NSDate *)date;
/// 年月日时分秒完整时间字符串获取date
+ (NSDate *)getDateAllTime:(NSString *)dateStr;

/// dict转json
+ (NSString*)dictionaryToJson:(NSDictionary *)dict;
/// json转dict
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
/// date返回日期选择
+ (NSDateComponents *)getDateComps:(NSDate *)date;
/// 分不失精度转元
+ (NSString *)moneyCentChangedYuan:(double)cent;

/// 给浮点型的数字字符串添加千分位分割,
+ (NSString *)stringFormatThousandSeparatorWithFloatStr:(NSString *)string;
/// 给整型的数字字符串添加千分位分割,
+ (NSString *)stringFormatThousandSeparatorWithIntStr:(NSString *)string;

/// 获取一个随机整数
+ (NSInteger)getRandomNumber:(NSInteger)from to:(NSInteger)to;
/// 获取固定位数的随机数字符串
+ (NSString *)getRandomNums:(NSInteger)nums;
/// 获取固定位数的随机中文
+ (NSString *)getRandomChinese:(NSInteger)nums;
/// 获取随机位数的随机字符串
+ (NSString *)getRandomString;
/// 获取小于多少位的随机字符串
+ (NSString *)getRandomStringWithLess:(NSInteger)lessNum;
/// 从acsii码中获取指定位数的随机字符串
+ (NSString *)setupACSIIStringWithNums:(NSInteger)nums letters:(NSInteger)letters signs:(NSInteger)signs;
/// 判断是否为整形字符串：
+ (BOOL)isPureInt:(NSString*)string;
/// 判断是否为浮点形字符串
+ (BOOL)isPureFloat:(NSString*)string;
/// 判断字符串中是否有中文
+ (BOOL)inclusionChineseWithStr:(NSString *)str;
/// 返回utf8的nsdata
+ (NSData *)replaceNoUtf8:(NSData *)data;
/// 求累加和(校验和)(CHECKSUM)的求法
+ (NSData *)getCheckSum:(NSData *)byteStr;
/// 将十进制转化为十六进制
+ (NSString *)ToHex:(NSInteger)tmpid;
/// NSData直转为字符串显示
+ (NSString *)convertToNSStringWithNSData:(NSData *)data;
/// 十六进制字符串转NSData
+ (NSData *)convertHexStrToData:(NSString *)str;
/// NSData转十六进制
+ (NSString *)convertDataToHexStr:(NSData *)data;
/// 26进制字符串转10进制
+ (NSString *)getDecimalismWithTwentysixHexadecimal:(NSString *)tsStr;
/// 获取当前设备IP地址 需要引入#include <ifaddrs.h> #include <arpa/inet.h>
+ (NSString *)getDeviceIP;
/// 拍照图片不正时图片旋转
+ (UIImage *)fixOrientation:(UIImage *)image;
@end

//
//  XDTools.m
//  ImageEdit
//
//  Created by miaoxiaodong on 2017/4/26.
//  Copyright © 2017年 markmiao. All rights reserved.
//

#import "XDTools.h"
#import "NSString+XD.h"


@implementation XDTools
/**
 *  正则判断手机号
 */
+(BOOL)isPhoneNum:(NSString *)string {
    NSString* regex = @"^1[3-9]\\d{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:string];
}

+ (void)contentSizeToFit:(UITextView *)textView {
    //先判断一下有没有文字（没文字就没必要设置居中了）
    if(textView.text.length > 0) {
        //textView的contentSize属性
        CGSize contentSize = textView.contentSize;
        //textView的内边距属性
        UIEdgeInsets offset;
        CGSize newSize = contentSize;
        
        //如果文字内容高度没有超过textView的高度
//        if(contentSize.height <= textView.frame.size.height) {
            //textView的高度减去文字高度除以2就是Y方向的偏移量，也就是textView的上内边距
            CGFloat offsetY = (textView.frame.size.height - contentSize.height)/2;
            offset = UIEdgeInsetsMake(offsetY, 0, 0, 0);
//        } else {          //如果文字高度超出textView的高度
//            newSize = textView.frame.size;
//            offset = UIEdgeInsetsZero;
//            CGFloat fontSize = 18;
//            
//            //通过一个while循环，设置textView的文字大小，使内容不超过整个textView的高度（这个根据需要可以自己设置）
//            while (contentSize.height > textView.frame.size.height) {
//                [textView setFont:[UIFont fontWithName:@"Helvetica Neue" size:fontSize--]];
//                contentSize = textView.contentSize;
//            }
//            newSize = contentSize;
//        }
        
        //根据前面计算设置textView的ContentSize和Y方向偏移量
        [textView setContentSize:newSize];
        [textView setContentInset:offset];
        
    }
}
+ (NSString *)removeUnescapedCharacter:(NSString *)inputStr {
    NSCharacterSet *controlChars = [NSCharacterSet controlCharacterSet];//获取那些特殊字符
    NSRange range = [inputStr rangeOfCharacterFromSet:controlChars];//寻找字符串中有没有这些特殊字符
    if (range.location != NSNotFound) {
        NSMutableString *mutable = [NSMutableString stringWithString:inputStr];
        while (range.location != NSNotFound)
        {
            [mutable deleteCharactersInRange:range];//去掉这些特殊字符
            range = [mutable rangeOfCharacterFromSet:controlChars];
        }
        return mutable;
    }
    return inputStr;
}
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if(error) {
        XDLog(@"json解析失败：%@",error);
        return nil;
    }
    return dic;
}
+ (NSString*)dictionaryToJson:(NSDictionary *)dict {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return [self removeUnescapedCharacter:jsonStr];
}
+ (UIView *)copyViewWith:(UIView *)view {
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}
+ (BOOL)isFontIsExist:(NSString *)fontName {
    UIFont* font = [UIFont fontWithName:fontName size:12.0];
    if (font && ([font.fontName compare:fontName] == NSOrderedSame || [font.familyName compare:fontName] == NSOrderedSame)) {
        return YES;
    } else {
        return NO;
    }
}
+ (BOOL)isTheSameColor2:(UIColor*)color1 anotherColor:(UIColor*)color2 {
    if (CGColorEqualToColor(color1.CGColor, color2.CGColor)) {
        return YES;
    } else {
        return NO;
    }
}

+ (AppDelegate *)getAppDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

+ (NSString *)getTimeWithIntervalSince:(NSString *)timeStr {
    NSTimeInterval time = timeStr.doubleValue;
    if (timeStr.length >= 13) {
        time = timeStr.doubleValue / 1000;
    }
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:newDate];
}

+ (NSInteger)getMonthDaysWithYear:(NSInteger)year Month:(NSInteger)month {
    NSMutableArray *daysArray = [NSMutableArray arrayWithArray:@[@0, @31, @28, @31, @30, @31, @30, @31, @31, @30, @31, @30, @31]];
    
    if (2 == month && (year % 400 == 0 || (year % 100 != 0 && year % 4 == 0))) {
        return 29;
    }
    return [daysArray[month] integerValue];
}
+ (NSString *)getNowTime2:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}
+ (NSString *)getNowAllTime2:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}
+ (NSDate *)getDateAllTime:(NSString *)dateStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter dateFromString:dateStr];
}

+ (NSDateComponents *)getDateComps:(NSDate *)date {
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitHour | NSCalendarUnitSecond | NSCalendarUnitMinute fromDate:date];
}
+ (NSString *)moneyCentChangedYuan:(double)cent {
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", cent]];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:@"100"];
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSDecimalNumber *num = [num1 decimalNumberByDividingBy:num2 withBehavior:handler];//进行四舍五入
    return [NSString stringWithFormat:@"%.2f", num.doubleValue];
}
+ (NSString *)stringFormatThousandSeparatorWithFloatStr:(NSString *)string {
    NSArray *strings = [string componentsSeparatedByString:@"."];
    if (strings.count > 2) {
        return string;
    } else if (strings.count < 2) {
        return [self stringFormatThousandSeparatorWithIntStr:string];
    } else {
        NSString *frontMoney = [self stringFormatThousandSeparatorWithIntStr:strings[0]];
        if([frontMoney isEqualToString:@""]){
            frontMoney = @"0";
        }
        return [NSString stringWithFormat:@"%@.%@", frontMoney,strings[1]];
    }
}
+ (NSString *)stringFormatThousandSeparatorWithIntStr:(NSString *)string {
    if (string.length <= 0) {
        return @"".mutableCopy;
    }
    NSString *tempRemoveD = [string stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSMutableString *stringM = [NSMutableString stringWithString:tempRemoveD];
    NSInteger n = 2;
    for (NSInteger i = tempRemoveD.length - 3; i > 0; i--) {
        n++;
        if (n == 3) {
            [stringM insertString:@"," atIndex:i];
            n = 0;
        }
    }
    return stringM;
}
+ (NSInteger)getRandomNumber:(NSInteger)from to:(NSInteger)to {
    if (from == 1 && to == 10) {
        return arc4random_uniform(10) + 1;
    }
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
}
+ (NSString *)getRandomNums:(NSInteger)nums {
    NSMutableString *numStr = [NSMutableString stringWithFormat:@""];
    for (NSInteger i = 0; i < nums; i++) {
        [numStr appendString:[NSString stringWithFormat:@"%u", arc4random_uniform(10)]];
    }
    return numStr;
}
+ (NSString *)getRandomChinese:(NSInteger)nums {
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSMutableString *numStr = [NSMutableString stringWithFormat:@""];
    for (NSInteger i = 0; i < nums; i ++) {
        NSInteger randomH = 0xA1+arc4random()%(0xFE - 0xA1+1);
        NSInteger randomL = 0xB0+arc4random()%(0xF7 - 0xB0+1);
        NSInteger number = (randomH<<8)+randomL;
        NSData *data = [NSData dataWithBytes:&number length:2];
        NSString *string = [[NSString alloc] initWithData:data encoding:gbkEncoding];
        [numStr appendString:string];
    }
    XDLog(@"随机中文 = %@", numStr);
    return [NSString stringWithFormat:@"%@", numStr];
}
+ (NSString *)getRandomString {
    NSMutableString *randomStr = [NSMutableString stringWithFormat:@""];
    NSInteger num = [self getRandomNumber:1 to:20];
    for (NSInteger i = 0; i < num; i ++) {
        NSInteger type = [self getRandomNumber:1 to:20];
        switch (type % 2) {
            case 0:
                [randomStr appendString:[self setupACSIIStringWithNums:type letters:0 signs:0]];
                break;
            case 1:
                [randomStr appendString:[self setupACSIIStringWithNums:0 letters:type signs:0]];
                break;
            default:
                break;
        }
    }
    return [NSString stringWithFormat:@"%@", randomStr];
}
+ (NSString *)getRandomStringWithLess:(NSInteger)lessNum {
    NSMutableString *randomStr = [NSMutableString stringWithFormat:@""];
    NSInteger num = [self getRandomNumber:1 to:lessNum];
    for (NSInteger i = 0; i < num; i ++) {
        if (arc4random_uniform(10) % 2) {
            [randomStr appendString:[self setupACSIIStringWithNums:1 letters:0 signs:0]];
        } else {
            [randomStr appendString:[self setupACSIIStringWithNums:0 letters:1 signs:0]];
        }
    }
    return [NSString stringWithFormat:@"%@", randomStr];
}
/*
 字母acsii码 大写字母 65-90 小写字母97-122
 单个符号  33-47   58-64  91-96 123-126
 */
+ (NSString *)setupACSIIStringWithNums:(NSInteger)nums letters:(NSInteger)letters signs:(NSInteger)signs {
    NSString *numStr = [self getRandomNums:nums];
    
    NSMutableString *letterStr = [NSMutableString stringWithFormat:@""];
    for (NSInteger i = 0; i < letters; i++) {
        NSInteger letterInt = 0;
        do {
            letterInt = [self getRandomNumber:65 to:122];
        } while (letterInt > 90 && letterInt < 97);
        [letterStr appendString:[NSString stringWithFormat:@"%c", (char)letterInt]];
    }
    
    NSMutableString *signStr = [NSMutableString stringWithFormat:@""];
    for (NSInteger i = 0; i < signs; i++) {
        NSInteger signInt = 0;
        do {
            signInt = [self getRandomNumber:33 to:126];
        } while ((signInt > 47 && signInt < 58) || (signInt > 64 && signInt < 91) || (signInt > 96 && signInt < 123));
        //        HXLog(@"符号的数字 = %ld", signInt);
        [signStr appendString:[NSString stringWithFormat:@"%c", (char)signInt]];
    }
    //    HXLog(@"数字 = %ld 字母 = %@ 符号 = %@", num, letterStr, signStr);
    return [NSString stringWithFormat:@"%@%@%@", numStr, letterStr, signStr];
}

//判断是否为整形：
+ (BOOL)isPureInt:(NSString*)string {
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
//判断是否为浮点形：
+ (BOOL)isPureFloat:(NSString*)string {
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
/** 判断字符串中是否有中文 */
+ (BOOL)inclusionChineseWithStr:(NSString *)str {
    /// 正则判断
//    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
//    return [predicate evaluateWithObject:str];
    for(int i = 0; i< str.length; i ++) {
        unichar ch = [str characterAtIndex:i];
        if (ch >= 0x4E00 && ch <= 0x9FA5) {
            return YES;
        }
    }
    return NO;
}
+ (NSData *)replaceNoUtf8:(NSData *)data {
    char aa[] = {'A','A','A','A','A','A'};                      //utf8最多6个字符，当前方法未使用
    NSMutableData *md = [NSMutableData dataWithData:data];
    int loc = 0;
    while(loc < [md length]) {
        char buffer;
        [md getBytes:&buffer range:NSMakeRange(loc, 1)];
        if((buffer & 0x80) == 0) {
            loc++;
            continue;
        } else if((buffer & 0xE0) == 0xC0) {
            loc++;
            [md getBytes:&buffer range:NSMakeRange(loc, 1)];
            if((buffer & 0xC0) == 0x80) {
                loc++;
                continue;
            }
            loc--;
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        } else if((buffer & 0xF0) == 0xE0) {
            loc++;
            [md getBytes:&buffer range:NSMakeRange(loc, 1)];
            if((buffer & 0xC0) == 0x80) {
                loc++;
                [md getBytes:&buffer range:NSMakeRange(loc, 1)];
                if((buffer & 0xC0) == 0x80)
                {
                    loc++;
                    continue;
                }
                loc--;
            }
            loc--;
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        } else {
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
    }
    return md;
}

+ (NSData *)getCheckSum:(NSData *)byteStr {
    int length = (int)byteStr.length;
    // NSData *data = [self hexToBytes:byteStr];
    Byte *bytes = (unsigned char *)[byteStr bytes];
    Byte sum = 0;
    for (int i = 0; i<length; i++) {
        sum += bytes[i];
    }
    int sumT = sum;
    int at = 256 -  sumT;
    if (at == 256) {
        at = 0;
    }
    NSString *str = [NSString stringWithFormat:@"%@",[self ToHex:sumT]];
    return [str hexToData];
}
//将十进制转化为十六进制
+ (NSString *)ToHex:(NSInteger)tmpid {
    NSString *nLetterValue;
    NSString *str =@"";
    int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig) {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%u",ttmpig];
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
    }
    //NSLog(@"16进制是：%@",str);
    //不够一个字节凑0
    if(str.length == 1){
        return [NSString stringWithFormat:@"0%@",str];
    }else{
        return str;
    }
}
+ (NSString *)convertToNSStringWithNSData:(NSData *)data {
    NSMutableString *strTemp = [NSMutableString stringWithCapacity:[data length]*2];
    const unsigned char *szBuffer = [data bytes];
    for (NSInteger i=0; i < [data length]; ++i) {
        [strTemp appendFormat:@"%02lx",(unsigned long)szBuffer[i]];
    }
    return strTemp;
}
+ (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
    return hexData;
}
+ (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}
+ (NSString *)getDecimalismWithTwentysixHexadecimal:(NSString *)tsStr {
    NSString *formworkStr = @"JAHOGVZFEIPWBRMUDQNLSYCKXT";
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < tsStr.length; i ++) {
        NSString *str = [tsStr substringWithRange:NSMakeRange(i, 1)];
        if ([formworkStr containsString:str]) {
            NSRange ranger = [formworkStr rangeOfString:str];
            [array addObject:[NSString stringWithFormat:@"%ld", ranger.location]];
        }
    }
    NSInteger sum = 0;
    for (NSInteger i = 0; i < array.count; i ++) {
        sum += [array[i] integerValue] * (NSInteger)pow(26, array.count - 1 - i);
    }
    return [NSString stringWithFormat:@"%ld", sum];
}
+ (NSString *)getDeviceIP {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    if (success == 0) { // 0 表示获取成功
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address;
}
+ (UIImage *)fixOrientation:(UIImage *)image {
    if (image.imageOrientation == UIImageOrientationUp)
        return image;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform,M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width,0);
            transform = CGAffineTransformRotate(transform,M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform,0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width,0);
            transform = CGAffineTransformScale(transform, -1,1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height,0);
            transform = CGAffineTransformScale(transform, -1,1);
            break;
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage),0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx,CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx,CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
@end

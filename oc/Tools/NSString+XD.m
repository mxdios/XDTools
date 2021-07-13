//
//  NSString+XD.m
//  BLEDisplay
//
//  Created by miaoxiaodong on 2018/4/11.
//  Copyright © 2018年 inspiry. All rights reserved.
//

#import "NSString+XD.h"

@implementation NSString (XD)
-(NSData *)hexToData {
    NSMutableData* data = [NSMutableData data];
    int idx;
    NSString *str = [[[self stringByReplacingOccurrencesOfString:@" " withString:@""]
                      stringByReplacingOccurrencesOfString:@"\r" withString:@""]
                     stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    for (idx = 0; idx+2 <= str.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [str substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

-(NSData *)UTF8ToData{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

-(NSString *)dataToHex:(NSData *)data{
    if (data.length){
        return [[[[NSString stringWithFormat:@"%@",data]
                  stringByReplacingOccurrencesOfString:@"<" withString:@""]
                 stringByReplacingOccurrencesOfString:@">" withString:@""]
                stringByReplacingOccurrencesOfString:@" " withString:@""];
    }else{
        return @"";
    }
}

-(NSString *)dataToUTF8:(NSData *)data{
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
@end

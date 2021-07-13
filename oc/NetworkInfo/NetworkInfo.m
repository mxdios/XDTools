//
//  NetworkInfo.m
//  inspos
//
//  Created by miaoxiaodong on 2021/6/8.
//  Copyright © 2021 inspiry. All rights reserved.
//

#import "NetworkInfo.h"
#import "Reachability.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@implementation NetworkInfo
+ (NSString *)getNetconnType {
    NSString *netconnType = @"-";
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:// 没有网络
        {
            netconnType = @"-";
        }
            break;
        case ReachableViaWiFi:// Wifi
        {
            netconnType = @"WiFi";
        }
            break;
        case ReachableViaWWAN:// 手机自带网络
        {
            // 获取手机网络类型
            CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
            NSString *currentStatus = info.currentRadioAccessTechnology;
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]) {
                netconnType = @"4G";
            } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"] ||
                       [currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"] ||
                       [currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"] ||
                       [currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]) {
                netconnType = @"3G";
            } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"] ||
                       [currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]) {
                netconnType = @"3.5G HSDPA";
            } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
                netconnType = @"GPRS";
            } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
                netconnType = @"2.75G EDGE";
            } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]) {
                netconnType = @"2G";
            } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]) {
                netconnType = @"HRPD";
            }
        }
            break;
        default:
            break;
    }
    return netconnType;
}
@end

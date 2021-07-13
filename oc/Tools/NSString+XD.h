//
//  NSString+XD.h
//  BLEDisplay
//
//  Created by miaoxiaodong on 2018/4/11.
//  Copyright © 2018年 inspiry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XD)
-(NSData*) hexToData;
-(NSData*) UTF8ToData;
-(NSString*) dataToHex:(NSData*)data;
-(NSString*) dataToUTF8:(NSData*)data;
@end

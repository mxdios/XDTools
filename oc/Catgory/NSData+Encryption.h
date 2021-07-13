//
//  NSData+Encryption.h
//  gasstation
//
//  Created by inspiry on 16/4/14.
//  Copyright © 2016年 inspiry. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSData (Encryption)
/** 加密 */
- (NSData *)AES256EncryptWithKey:(NSString *)key;

/** 解密 */
- (NSData *)AES256DecryptWithKey:(NSString *)key;
@end

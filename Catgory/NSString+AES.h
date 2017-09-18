//
//  NSString+AES.h
//  gasstation
//
//  Created by inspiry on 16/4/14.
//  Copyright © 2016年 inspiry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "NSData+Encryption.h"

@interface NSString (AES)
-(NSString *) aes256_encrypt:(NSString *)key;
-(NSString *) aes256_decrypt:(NSString *)key;

@end

//
//  XDNetworkingTool.h
//  paipaiaudit
//
//  Created by miaoxiaodong on 2017/7/17.
//  Copyright © 2017年 miaoxiaodong. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 请求成功block

 @param responseObject 请求成功block
 */
typedef void (^SuccessBlock) (NSURLSessionDataTask *task, id responseObject);

/**
 body post请求结束block
 */
typedef void (^bodyPostBlock)(NSURLResponse *response,id responseObject,NSError *error);
/**
 请求失败block

 @param error 请求失败block
 */
typedef void (^FailedBlock) (NSURLSessionDataTask *task, NSError *error);

/**
 下载完成的block

 @param response 请求
 @param filePath 路径
 @param error 失败
 */
typedef void (^CompletionHandlerBlock) (NSURLResponse * response, NSURL * filePath, NSError * error);

/**
 下载进度
 */
typedef void (^ProgressBlock) (NSProgress *downloadProgress);
//返回值数据类型枚举
typedef enum : NSUInteger {
    XDData,
    XDJSON,
    XDXML
} XDResult;

//请求参数的类型枚举
typedef enum: NSUInteger {
    XDRequestJSON,
    XDRequestString
} XDRequestStyle;


@interface XDNetworkingTool : NSObject

/**
 get请求

 @param url 请求地址
 @param parmenters 请求参数
 @param result 返回值数据类型
 @param headerFile 请求头
 @param successBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)XD_GET:(NSString *)url
    parmenters:(id)parmenters
        result:(XDResult)result
    headerFile:(NSDictionary *)headerFile
       success:(SuccessBlock)successBlock
       failure:(FailedBlock)failedBlock;

/**
 post请求

 @param url 请求地址
 @param parmenters 请求参数
 @param result 返回值数据类型
 @param requestStyle 请求参数数据类型
 @param headerFile 请求头
 @param successBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)XD_POST:(NSString *)url
     parmenters:(id)parmenters
         result:(XDResult)result
   requestStyle:(XDRequestStyle)requestStyle
     headerFile:(NSDictionary *)headerFile
        success:(SuccessBlock)successBlock
        failure:(FailedBlock)failedBlock;


/**
 post请求，

 @param url 请求地址
 @param bodyDict body参数
 */
+ (void)XD_POSTBody:(NSString *)url
           bodyDict:(NSDictionary *)bodyDict
          postBlock:(bodyPostBlock)postBlock;

/**
 下载

 @param url 下载地址
 @param progress 下载进度
 @param completion 下载完成
 @return 下载任务
 */
+ (NSURLSessionDownloadTask *)XD_Download:(NSString *)url
                                 progress:(ProgressBlock)progress
                        completionHandler:(CompletionHandlerBlock)completion;
@end


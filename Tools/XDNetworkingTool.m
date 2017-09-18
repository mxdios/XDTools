//
//  XDNetworkingTool.m
//  paipaiaudit
//
//  Created by miaoxiaodong on 2017/7/17.
//  Copyright © 2017年 miaoxiaodong. All rights reserved.
//

#import "XDNetworkingTool.h"
#import "AFNetworking.h"

@implementation XDNetworkingTool

+ (void)XD_GET:(NSString *)url
    parmenters:(id)parmenters
        result:(XDResult)result
    headerFile:(NSDictionary *)headerFile
       success:(SuccessBlock)successBlock
       failure:(FailedBlock)failedBlock {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    switch (result) {
        case XDData:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        case XDJSON:
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case XDXML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        default:
            break;
    }
    if (headerFile) {
        for (NSString *key in headerFile.allKeys) {
            [manager.requestSerializer setValue:headerFile[key] forHTTPHeaderField:key];
        }
    }
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript", nil]];
    [manager GET:url parameters:parmenters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failedBlock) {
            failedBlock(task, error);
        }
    }];
}

+ (void)XD_POST:(NSString *)url
     parmenters:(id)parmenters
         result:(XDResult)result
   requestStyle:(XDRequestStyle)requestStyle
     headerFile:(NSDictionary *)headerFile
        success:(SuccessBlock)successBlock
        failure:(FailedBlock)failedBlock {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    switch (result) {
        case XDData:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        case XDJSON:
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case XDXML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        default:
            break;
    }
    switch (requestStyle) {
        case XDRequestJSON:
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case XDRequestString:
            [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, id parameters, NSError *__autoreleasing *error) {
                return parameters;
            }];
        default:
            break;
    }
    if (headerFile) {
        for (NSString *key in headerFile.allKeys) {
            [manager.requestSerializer setValue:headerFile[key] forHTTPHeaderField:key];
        }
    }
    [manager POST:url parameters:parmenters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failedBlock) {
            failedBlock(task, error);
        }
    }];
}

+ (NSURLSessionDownloadTask *)XD_Download:(NSString *)url
                                 progress:(ProgressBlock)progress
                        completionHandler:(CompletionHandlerBlock)completion {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        NSString *fileName = [cachePath stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:fileName];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (completion) {
            completion(response, filePath, error);
        }
    }];
    return task;
}
+ (void)XD_POSTBody:(NSString *)url
           bodyDict:(NSDictionary *)bodyDict
          postBlock:(bodyPostBlock)postBlock {
    NSData *body= [NSJSONSerialization dataWithJSONObject:bodyDict options:NSJSONWritingPrettyPrinted error:nil];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    request.timeoutInterval = 10;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:body];
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript",@"text/plain",nil];
    manager.responseSerializer = responseSerializer;
    [[manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response,id responseObject,NSError *error){
        if (postBlock) {
            postBlock(response, responseObject, error);
        }
    }] resume];
}
@end

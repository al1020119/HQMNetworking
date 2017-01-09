//
//  HQMUploadRequest.m
//  HQMNetworking
//
//  Created by 小伴 on 2017/1/9.
//  Copyright © 2017年 huangqimeng. All rights reserved.
//

#import "HQMUploadRequest.h"

#import "AFNetworking.h"

@implementation HQMUploadRequest

- (HQMRequestMethod)requestMethod {
    return HQMRequestMethodPOST;
}

- (NSString *)requestURLPath {
    return @"/index.php/Api/User/upload_user_avatar";
}

- (NSDictionary *)requestArguments {
    return @{
             ///< 注意：两种方式传参 --> 1.直接设置 POST 请求的参数来传递
//             @"uid": @"1181",
//             @"token": @"12d2eae5d0ec3b8b3d965f388127ddfd"
             };
}

- (AFConstructingBodyBlock)constructingBodyBlock {
    @weakify(self);
    void (^bodyBlock)(id<AFMultipartFormData> formData) = ^(id<AFMultipartFormData> formData) {
        @strongify(self);
        if (self.avatar) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置日期格式
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSString *fileName = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];

            [formData appendPartWithFileData:self.avatar name:@"file" fileName:fileName mimeType:@"image/png"];

            ///< 注意：两种方式传参 --> 2.通过 body 体传
            NSString *token = @"12d2eae5d0ec3b8b3d965f388127ddfd";
            NSString *uid = @"1181";
            //直接拼接参数 注意 参数 要和服务端的字段一致
            [formData appendPartWithFormData:[token dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
            [formData appendPartWithFormData:[uid dataUsingEncoding:NSUTF8StringEncoding] name:@"uid"];
        }
    };
    
    return bodyBlock;
}

- (void)handleData:(id)data errCode:(NSInteger)resCode {
    NSDictionary *dict = (NSDictionary *)data;
    NSString *path = nil;
    if (VALID_DICTIONARY(dict)) {
        path = [dict objectForKey:@"path"];
    }
    if (self.successBlock) {
        self.successBlock(resCode,nil,path);
    }
}

@end

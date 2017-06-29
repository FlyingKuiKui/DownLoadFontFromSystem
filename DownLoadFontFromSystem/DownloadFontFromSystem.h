//
//  DownloadFontFromSystem.h
//  DownLoadFontFromSystem
//
//  Created by 王盛魁 on 2017/6/29.
//  Copyright © 2017年 WangShengKui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadFontFromSystem : NSObject
+ (void)downloadFontWithPostScriptName:(NSString *)postScriptName
                              Progress:(void (^)(double progressValue))progress
                               Success:(void (^)(void))success
                                 Fail:(void (^)(NSString *errorMessage))fail;

@end

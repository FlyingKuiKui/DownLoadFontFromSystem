//
//  DownloadFontFromSystem.m
//  DownLoadFontFromSystem
//
//  Created by 王盛魁 on 2017/6/29.
//  Copyright © 2017年 WangShengKui. All rights reserved.
//

#import "DownloadFontFromSystem.h"
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@implementation DownloadFontFromSystem

+ (void)downloadFontWithPostScriptName:(NSString *)postScriptName
                              Progress:(void (^)(double progressValue))progress
                               Success:(void (^)(void))success
                                  Fail:(void (^)(NSString *errorMessage))fail{
    if ([self isFontDownloaded:postScriptName]) {
        return;
    }
    NSMutableDictionary *attrsDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:postScriptName,kCTFontNameAttribute, nil];
    CTFontDescriptorRef descriptor = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attrsDictionary);
    NSMutableArray *descriptorArray = [NSMutableArray array];
    [descriptorArray addObject:(__bridge id)descriptor];
    CFRelease(descriptor);
    __block BOOL errorDuringDownload = NO;
    CTFontDescriptorMatchFontDescriptorsWithProgressHandler((__bridge CFArrayRef)descriptorArray, NULL, ^bool(CTFontDescriptorMatchingState state, CFDictionaryRef  _Nonnull progressParameter) {
        double progressValue = [[(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingPercentage] doubleValue];
        if (state == kCTFontDescriptorMatchingDidBegin) {
            NSLog(@"字体开始匹配");
        }else if (state == kCTFontDescriptorMatchingDidFinish){
            if (!errorDuringDownload) {
                NSLog(@"字体%@匹配完成",postScriptName);
            }
        }else if (state == kCTFontDescriptorMatchingWillBeginDownloading){
            NSLog(@"%@字体开始下载",postScriptName);
        }else if (state == kCTFontDescriptorMatchingDidFinishDownloading){
            dispatch_async(dispatch_get_main_queue(), ^{
                // 在此修改UI控件的字体
                success();
            });
        }else if (state == kCTFontDescriptorMatchingDownloading){
            progress(progressValue);
        }else if (state == kCTFontDescriptorMatchingDidFailWithError){
            NSError *error = [(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingError];
            NSString *errorMesage = [NSString string];
            if (error != nil) {
                errorMesage = [error description];
            } else {
                errorMesage = @"ERROR MESSAGE IS NOT AVAILABLE!";
            }
            // 设置下载失败标志
            errorDuringDownload = YES;
            fail(errorMesage);
        }
        return (bool)YES;
    });
    
}
// 验证字体是否已被下载
+ (BOOL)isFontDownloaded:(NSString *)postScriptName{
    UIFont *font = [UIFont fontWithName:postScriptName size:12.0];
    if (font && ([font.fontName compare:postScriptName] == NSOrderedSame || [font.familyName compare:postScriptName] == NSOrderedSame)) {
        return YES;
    }
    return NO;
}
@end

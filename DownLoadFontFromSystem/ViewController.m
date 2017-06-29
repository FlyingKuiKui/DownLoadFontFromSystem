//
//  ViewController.m
//  DownLoadFontFromSystem
//
//  Created by 王盛魁 on 2017/6/29.
//  Copyright © 2017年 WangShengKui. All rights reserved.
//

#import "ViewController.h"
#import "DownloadFontFromSystem.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [DownloadFontFromSystem downloadFontWithPostScriptName:@"STKaitiSC-Regular" Progress:^(double progressValue) {
        NSLog(@">>下载进度%.0f%%",progressValue);
    } Success:^{
        NSLog(@">>下载成功");
    } Fail:^(NSString *errorMessage) {
        NSLog(@">>下载失败");
    }];

    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

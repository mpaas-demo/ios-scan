//
//  MPScanDemoVC.m
//  MPScanDemo
//
//  Created by shifei.wkp on 2018/12/18.
//  Copyright © 2018 alipay. All rights reserved.
//

#import "MPScanDemoVC.h"
#import "MPScanCodeViewController.h"
#import "MPScanDemoDef.h"

@implementation MPScanDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"扫一扫";
    self.view.backgroundColor = AU_COLOR_CLIENT_BG1;
    
    CREATE_UI({
        BUTTON_WITH_ACTION(@"全屏扫码页面", fullScan)
        BUTTON_WITH_ACTION(@"默认样式扫码页面", defaultScan)
        BUTTON_WITH_ACTION(@"自定义扫码页面", customScan)
    })
    
}

- (void)fullScan {
    TBScanViewController *vc = [TBScanViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)defaultScan {
    MPScanCodeViewController *vc = [[MPScanCodeViewController alloc] init];
    vc.usingDefaultStyle = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)customScan {
    MPScanCodeViewController *vc = [[MPScanCodeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

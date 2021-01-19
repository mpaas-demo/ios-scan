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

@interface MPScanDemoVC()
 @property(nonatomic, strong) TBScanViewController *scanVC;
 @end

@implementation MPScanDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"扫一扫";
    self.view.backgroundColor = AU_COLOR_CLIENT_BG1;
    
    CREATE_UI({
        BUTTON_WITH_ACTION(@"默认样式扫码页面", defaultScan)
        BUTTON_WITH_ACTION(@"自定义默认样式扫码页面", custoDefaultScan)
        BUTTON_WITH_ACTION(@"自定义扫码页面", customScan)
    })
}

- (void)defaultScan {
    TBScanViewController *vc = [[MPScanCodeAdapterInterface sharedInstance] createDefaultScanPageWithallback:^(id  _Nonnull result, BOOL keepAlive) {
       // 处理扫描结果
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:result[@"resp_result"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1999;
        [alert show];
    }];
    [self.navigationController pushViewController:vc animated:YES];
    self.scanVC =  vc;
}

- (void)custoDefaultScan {
   TBScanViewController *vc = [[MPScanCodeAdapterInterface sharedInstance] createDefaultScanPageWithallback:^(id  _Nonnull result, BOOL keepAlive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:result[@"resp_result"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1001;
        [alert show];
    }];
    [self.navigationController pushViewController:vc animated:YES];
    self.scanVC =  vc;
    // 设置扫码界面 title
    vc.title = @"标准扫码";
    // 设置打开手电筒提示文字
    vc.torchStateNormalTitle = @"打开手电筒";
    // 设置关闭手电筒提示文字
    vc.torchStateSelectedTitle = @"关闭手电筒";
    // 设置扫码识别类型
    vc.scanType =  ScanType_QRCode;
    // 设置选择相册按钮
    vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:APCommonUILoadImage(@"camera") style:UIBarButtonItemStylePlain target:self action:@selector(selectPhotos)];
}

- (void)selectPhotos
{
    [self.scanVC scanPhotoLibrary];
}


- (void)customScan {
    MPScanCodeViewController *vc = [[MPScanCodeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // 持续扫码
    [self.scanVC resumeScan];
}

@end

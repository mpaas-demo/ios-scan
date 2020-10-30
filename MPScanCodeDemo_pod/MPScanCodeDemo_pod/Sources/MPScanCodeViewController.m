//
//  MPScanCodeViewController.m
//  MPScanCodeDemo_pod
//
//  Created by shifei.wkp on 2019/3/28.
//  Copyright © 2019 Alibaba. All rights reserved.
//

#import "MPScanCodeViewController.h"

@interface MPScanCodeViewController ()

//@property (nonatomic, strong) UIView *maskView;
//@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
//@property (nonatomic, assign) BOOL viewHadAppear;
//@property (nonatomic, assign) BOOL cameraHadResume;

@end

@implementation MPScanCodeViewController

- (instancetype)init
{
    if (self = [super init])
    {
        self.delegate = self;
        self.scanType = ScanType_All_Code;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"扫码";
    // 自定义扫码界面大小
    CGRect rect = [MPScanCodeViewController constructScanAnimationRect];
    self.rectOfInterest = rect;
    // 自定义相册按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选择相册" style:UIBarButtonItemStylePlain target:self action:@selector(selectPhoto)];
}
+ (CGRect)constructScanAnimationRect
{
    CGSize screenXY = [UIScreen mainScreen].bounds.size;
    NSInteger focusFrameWH = screenXY.width / 320 * 220;//as wx
    int offet = 10;
    if (screenXY.height == 568)
        offet = 19;
    return CGRectMake((screenXY.width - focusFrameWH) / 2,
                      (screenXY.height - 64 - focusFrameWH - 83 - 50 - offet) / 2 + 64,
                      focusFrameWH,
                      focusFrameWH);
}
-(void)buildContainerView:(UIView*)containerView
{
    // 自定义扫码框 view
    UIView* bg = [[UIView alloc] initWithFrame:containerView.bounds];
    [containerView addSubview:bg];
    CGRect rect = [MPScanCodeViewController constructScanAnimationRect];
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor orangeColor];
    view.alpha = 0.5;
    [bg addSubview:view];
}
- (void)selectPhoto
{
    [self scanPhotoLibrary];
}

#pragma mark TBScanViewControllerDelegate

-(void)didFind:(NSArray<TBScanResult*>*)resultArray
{
    TBScanResult *result = resultArray.firstObject;
    NSString* content = result.data;
    if (result.resultType == TBScanResultTypeQRCode) {
        content = [NSString stringWithFormat:@"qrcode:%@, hiddenData:%@, TBScanQRCodeResultType:%@", result.data, result.hiddenData, [result.extData objectForKey:TBScanResultTypeQRCode]];
        NSLog(@"subType is %@, ScanType_QRCode is %@", @(result.subType), @(ScanType_QRCode));
    } else if (result.resultType == TBScanResultTypeVLGen3Code) {
        content = [NSString stringWithFormat:@"gen3:%@", result.data];
        NSLog(@"subType is %@, ScanType_GEN3 is %@", @(result.subType), @(ScanType_GEN3));
    } else if (result.resultType == TBScanResultTypeGoodsBarcode) {
        content = [NSString stringWithFormat:@"barcode:%@", result.data];
        NSLog(@"subType is %@, EAN13 is %@", @(result.subType), @(EAN13));
    } else if (result.resultType == TBScanResultTypeDataMatrixCode) {
        content = [NSString stringWithFormat:@"dm:%@", result.data];
        NSLog(@"subType is %@, ScanType_DATAMATRIX is %@", @(result.subType), @(ScanType_DATAMATRIX));
    } else if (result.resultType == TBScanResultTypeExpressCode) {
        content = [NSString stringWithFormat:@"express:%@", result.data];
        NSLog(@"subType is %@, ScanType_FASTMAIL is %@", @(result.subType), @(ScanType_FASTMAIL));
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:content delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 9999;
        [alert show];
    });
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    // 持续扫码
    [self resumeScan];
}

- (void)cameraPermissionDenied
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cameraDidStart
{
    NSLog(@"started!!");
}

-(void)setTorchState:(TorchState)bState
{
    NSLog(@"TorchState:%lu", (unsigned long)bState);
}

-(void)setImagePickerNavigationBarStyle:(UINavigationBar *)navigationBar
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0){
        navigationBar.barStyle = UIBarStyleBlack;
        navigationBar.translucent = YES;
        navigationBar.barTintColor = [UIColor colorWithRed:20.f/255.0 green:24.0/255.0 blue:38.0/255.0 alpha:1];
        navigationBar.tintColor = [UIColor whiteColor];
    }
}

-(void)userTrack:(NSString*)name
{
    NSLog(@"userTrack:%@", name);
}

-(void)userTrack:(NSString*)name args:(NSDictionary*)data
{
    NSLog(@"userTrack:%@, args:%@", name, data);
}

- (void)scanPhotoFailed
 {
     // 相册识别失败的回调
     NSLog(@"scanPhotoFailed");
 }


@end

//
//  ViewController.m
//  Account
//
//  Created by 朱元清 on 2021/4/1.
//

#import "ViewController.h"
#import <VEAppUpdateHelper/TTAppUpdateHelperDefault.h>
#import "UIApplication+BTDAdditions.h"
#import <OneKit/OKServiceCenter.h>
#import <OneKit/OKApplicationInfo.h>
#import <OneKit/OKServices.h>

@interface ViewController ()<TTAppUpdateDelegate>
@property (nonatomic, strong) TTAppUpdateHelperDefault *updateHelper;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __block id<OKDeviceService> deviceService = [[OKServiceCenter sharedInstance] serviceForProtocol:@protocol(OKDeviceService)];
    UITextField *label = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
    label.text = deviceService.deviceID;
    [self.view addSubview:label];
    
    [self update];
}

- (void)update {
    if(!self.updateHelper) {
        __block id<OKDeviceService> deviceService = [[OKServiceCenter sharedInstance] serviceForProtocol:@protocol(OKDeviceService)];
        OKApplicationInfo *info = [OKApplicationInfo sharedInstance];
        TTAppUpdateHelperDefault *defaultHelper = [[TTAppUpdateHelperDefault alloc] initWithDeviceID:deviceService.deviceID channel:@"beta" aid:info.appID delegate:self];
        self.updateHelper = defaultHelper;
        self.updateHelper.callType = @(0);
        self.updateHelper.city = @"Shanghai";
        [defaultHelper startCheckVersion];
    }
}

#pragma mark TTAppUpdateDelegate
- (void)updateViewShouldShow:(TTAppUpdateTipView *)tipView {
    [tipView show];
}

- (void)updateViewShouldClosed:(TTAppUpdateTipView *)tipView {
    [tipView hide];
    self.updateHelper = nil;
}
@end

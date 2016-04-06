//
//  ViewController.m
//  TOOSScrollBanner
//
//  Created by Stephen on 4/6/16.
//  Copyright © 2016 Stephen. All rights reserved.
//

#import "ViewController.h"
#import "TOOSBannerView.h"

@interface ViewController ()
<TOOSBannerViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    TOOSBannerView* bannerView = [[TOOSBannerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    bannerView.delegate = self;
    bannerView.bannerColor = [UIColor colorWithRed:11/255.0f green:206/255.0f blue:255/255.0f alpha:1];
    bannerView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:bannerView];
    [bannerView setBannerArray:@[@"http://ws.xzhushou.cn/focusimg/201508201549023.jpg",@"http://ws.xzhushou.cn/focusimg/52.jpg",@"http://ws.xzhushou.cn/focusimg/51.jpg",@"http://ws.xzhushou.cn/focusimg/50.jpg"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bannerView:(TOOSScrollBanner*)scrollbanner clickImgAtIndex:(NSInteger)index
{
    NSLog(@"bannerView select index: %ld", (long)index);
}

@end

//
//  TOOSBannerView.m
//  
//
//  Created by Stephen on 2/27/16.
//  Copyright © 2016 Stephen. All rights reserved.
//

#import "TOOSBannerView.h"

#import "TOOSScrollBanner.h"

@interface TOOSBannerView()
<
TOOSScrollBannerDelegate
>

@property (nonatomic, strong) TOOSScrollBanner* banner;

@end

@implementation TOOSBannerView

- (void)dealloc
{
    _banner = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.image = [UIImage imageNamed:@"banner_default"];
        imageView.userInteractionEnabled = YES;
        [self addSubview:imageView];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [imageView addGestureRecognizer:tap];
    }
    return self;
}

- (void)tap:(UITapGestureRecognizer*)gestureRecognizer
{
    if (self.delegate) {
        [self.delegate reloadBannerView];
    }
}

- (void)setBannerArray:(NSArray *)array
{
    [self removeBannerView];
    
    self.banner = [[TOOSScrollBanner alloc] initWithFrame:self.bounds withUrls:array];
    self.banner.AutoScrollDelay = 2;
    self.banner.effectEnabled = NO;
    self.banner.bannerColor = self.bannerColor;
    self.banner.delegate = self;
    
    self.banner.clipsToBounds = YES;
    [self addSubview:self.banner];
}

- (void)removeBannerView
{
    if (_banner) {
        if ([_banner isAnimating]) {
            [_banner stopAnimating];
        }
        _banner.delegate = nil;
        [_banner removeFromSuperview];
        _banner = nil;
    }
}

- (void)stopBannerAnimating
{
    if ([_banner isAnimating]) {
        [_banner stopAnimating];
    }
}

- (void)startBannerAnimating
{
    if (![_banner isAnimating]) {
        [_banner startAnimating];
    }
}

#pragma mark - TOOSScrollBanner
- (void)scrollBanner:(TOOSScrollBanner*)scrollbanner clickImgAtIndex:(NSInteger)index
{
    if (self.delegate) {
        [self.delegate bannerView:scrollbanner clickImgAtIndex:index];
    }
}

@end

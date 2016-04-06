// The MIT License (MIT)
//
// Copyright (c) 2016 ifshyse
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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

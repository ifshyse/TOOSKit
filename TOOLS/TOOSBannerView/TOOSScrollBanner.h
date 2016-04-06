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
//  TOOSScrollBanner.h
//  
//
//  Created by Stephen on 16/2/17.
//  Copyright © 2016年 Stephen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TOOSScrollBanner;

@protocol TOOSScrollBannerDelegate <NSObject>

- (void)scrollBanner:(TOOSScrollBanner*)scrollbanner clickImgAtIndex:(NSInteger)index;

@end
@interface TOOSScrollBanner : UIView

@property (nonatomic, assign) NSTimeInterval AutoScrollDelay;

@property (nonatomic, weak) id<TOOSScrollBannerDelegate> delegate;

@property (nonatomic, assign) BOOL effectEnabled;

@property (nonatomic, strong) UIColor* bannerColor;

- (instancetype)initWithFrame:(CGRect)frame withUrls:(NSArray*)urls;

- (BOOL)isAnimating;
- (void)stopAnimating;
- (void)startAnimating;

@end

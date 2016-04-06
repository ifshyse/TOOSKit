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

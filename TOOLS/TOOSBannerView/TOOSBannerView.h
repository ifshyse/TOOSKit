//
//  TOOSBannerView.h
//  iStudent
//
//  Created by Stephen on 2/27/16.
//  Copyright © 2016 taomee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TOOSScrollBanner;

@protocol TOOSBannerViewDelegate <NSObject>

@optional
- (void)bannerView:(TOOSScrollBanner*)scrollbanner clickImgAtIndex:(NSInteger)index;
- (void)reloadBannerView;

@end

@interface TOOSBannerView : UIView

@property (nonatomic , weak) id<TOOSBannerViewDelegate> delegate;

@property (nonatomic, strong) UIColor* bannerColor;

- (void)setBannerArray:(NSArray*)array;
- (void)removeBannerView;
- (void)stopBannerAnimating;
- (void)startBannerAnimating;

@end

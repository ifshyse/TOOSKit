//
//  TOOSScrollBanner.m
//  
//
//  Created by Stephen on 16/1/29.
//  Copyright © 2016年 Stephen. All rights reserved.
//

#import "TOOSScrollBanner.h"
#import "TAPageControl.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+RJLoader.h"

@interface TOOSScrollBanner ()<UIScrollViewDelegate>
{
    NSArray *imageUrls;
    TAPageControl *pageControl;
    CGRect mainFrame;
    NSTimer *_timer;
}

@property (nonatomic, strong) UIScrollView* scrollView;

@end

@implementation TOOSScrollBanner

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame withUrls:(NSArray*)urls
{
    self = [super init];
    if (self) {
        imageUrls = urls;
        mainFrame = frame;
        self.frame = mainFrame;
    }
    [self initialScrollView];
    return self;
}

- (void)initialScrollView {
    
    [self setScrollView];
    [self setImageViews];
    [self setPageControl];
}

#pragma mark - set
- (void)setScrollView {
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, mainFrame.size.width,mainFrame.size.height)];
    [self addSubview:_scrollView];
    _scrollView.delegate = self;
    [_scrollView setContentSize:CGSizeMake(mainFrame.size.width * (imageUrls.count + 2), 0)];
    [_scrollView setPagingEnabled:YES];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [_scrollView setContentOffset:CGPointMake(mainFrame.size.width, 0)];
}

- (void)setImageViews {
    for (int i = 0; i<imageUrls.count + 2; i++) {
        UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(i * mainFrame.size.width, 0, mainFrame.size.width, mainFrame.size.height)];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(-1, -1, mainFrame.size.width+2, mainFrame.size.height+2)];
        
        if (i == 0) {
            [self setImageWithUrl:imageUrls[imageUrls.count-1] atImageView:imageView];
            imageView.tag = imageUrls.count-1;
        }else if (i == imageUrls.count +1) {
            [self setImageWithUrl:imageUrls[0] atImageView:imageView];
            imageView.tag = 0;
        }else {
            [self setImageWithUrl:imageUrls[i-1] atImageView:imageView];
            imageView.tag = i-1;
        }
        [scroll addSubview:imageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgClick:)];
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled = YES;
        [imageView setContentMode:UIViewContentModeScaleToFill];
        [self.scrollView addSubview:scroll];
    }
}

- (void)setPageControl {
    pageControl = [[TAPageControl alloc]init];
    pageControl.frame = CGRectMake(0, self.scrollView.frame.size.height - 20 + self.scrollView.frame.origin.y, mainFrame.size.width, 20) ;
    [self addSubview:pageControl];
    pageControl.numberOfPages = imageUrls.count;
    pageControl.currentPage = 0;
}

- (void)setAutoScrollDelay:(NSTimeInterval)AutoScrollDelay {
    [self removeTimer];
    if (imageUrls.count == 1) {
        self.scrollView.scrollEnabled = NO;
        return;
    }
    self.scrollView.scrollEnabled = YES;
    _AutoScrollDelay = AutoScrollDelay;
    [self setUpTimer];
}

- (void)imgClick:(UITapGestureRecognizer *)tap {
    UIImageView *imgView = (UIImageView *)tap.view;
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollBanner:clickImgAtIndex:)]) {
        [self.delegate scrollBanner:self clickImgAtIndex:imgView.tag];
    }
}

- (void)setImageWithUrl:(NSString*)url atImageView:(UIImageView*)imageView
{
    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
    __weak typeof (self) weakSelf = self;
    [downloader downloadImageWithURL:[NSURL URLWithString:url]
                             options:0
                            progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                if (imageView && _effectEnabled == YES) {
                                    [imageView startLoaderWithTintColor:weakSelf.bannerColor];
                                    [imageView updateImageDownloadProgress:(CGFloat)receivedSize/expectedSize];
                                }
                            }
                           completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                               if (image && finished) {
                                   if (imageView) {
                                       imageView.image = image;
                                       [imageView reveal];
                                   }
                               }
                           }];
}

#pragma mark - 
- (BOOL)isAnimating
{
    if (_timer && _scrollView.scrollEnabled == YES) {
        return YES;
    }else {
        return NO;
    }
}

- (void)stopAnimating
{
    _scrollView.scrollEnabled = NO;
    [self removeTimer];
}

- (void)startAnimating
{
    _scrollView.scrollEnabled = YES;
    [self setUpTimer];
}

#pragma mark - NSTimer
- (void)setUpTimer {
    if (_AutoScrollDelay < 0.5) return;
    _timer = [NSTimer timerWithTimeInterval:_AutoScrollDelay target:self selector:@selector(scorll) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
}
- (void)scorll {
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + mainFrame.size.width, 0) animated:YES];
}

#pragma mark - UISCrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self setUpTimer];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeTimer];
}

- (void)removeTimer {
    if (_timer == nil) return;
    [_timer invalidate];
    _timer = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger x = scrollView.contentOffset.x/mainFrame.size.width;
    if (x == imageUrls.count +1) {
        [scrollView setContentOffset:CGPointMake(mainFrame.size.width, 0) animated:NO];
        [pageControl setCurrentPage:0];
    }else if (scrollView.contentOffset.x <= 0) {
        [scrollView setContentOffset:CGPointMake(mainFrame.size.width * imageUrls.count,0) animated:NO];
        [pageControl setCurrentPage:imageUrls.count-1];
    }else {
        [pageControl setCurrentPage:x-1];
    }
}

@end

//
//  TOOSTextLayout.h
//  TOOSLayoutExample
//
//  Created by Stephen on 4/6/16.
//  Copyright © 2016 Stephen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

/**
 *  vertical direction alignment
 */
typedef NS_ENUM(NSUInteger, TOOSVerticalAlignment){
    TOOSVerticalAlignmentTop,
    TOOSVerticalAlignmentCenter,
    TOOSVerticalAlignmentBottom,
};

@interface TOOSTextLayout : NSObject

/**
 *  text content, default is nil
 */
@property (nonatomic,copy) NSString* text;

/**
 *  attributed conrent, default is nil
 */
@property (nonatomic,strong) NSMutableAttributedString* attributedText;

/**
 *  text color，default is RGB(0,0,0,1)
 */
@property (nonatomic,strong) UIColor* textColor;

/**
 *  link color，default is RGB(0,0,0,1)
 */
@property (nonatomic,strong) UIColor* linkColor;

/**
 *  high light color，default is RGB(0,0,0,1)
 */
@property (nonatomic,strong) UIColor* highlightColor;

/**
 *  default font is [UIFont systemFontOfSize:17.0f]
 */
@property (nonatomic,strong) UIFont* font;

/**
 *  line cap
 */
@property (nonatomic,assign) CGFloat linespace;

/**
 *  text cap
 */
@property (nonatomic, assign) unichar characterSpacing;

/**
 *  text line count
 */
@property (nonatomic,assign) NSInteger numberOfLines;

/**
 *  horizontal text alignment
 */
@property (nonatomic,assign) NSTextAlignment textAlignment;

/**
 *  vertical text alignment
 */
@property (nonatomic,assign) TOOSVerticalAlignment veriticalAlignment;

/**
 *  underline style
 */
@property (nonatomic,assign) NSUnderlineStyle underlineStyle;

/**
 *  linebreak mode , default is NSLineBreakByWordWrapping
 */
@property (nonatomic) NSLineBreakMode lineBreakMode;

/**
 *  ctFrameRef
 */
@property (nonatomic,assign) CTFrameRef frame;

/**
 *  text height
 */
@property (nonatomic,assign) CGFloat textHeight;

/**
 *  text width
 *
 */
@property (nonatomic,assign) CGFloat textWidth;

/**
 * text bounds rect
 */
@property (nonatomic,assign) CGRect boundsRect;

/**
 *  attach array
 */
@property (nonatomic,strong) NSMutableArray* attachs;

/**
 *  is width to fit
 */
@property (nonatomic,assign,getter=isWidthToFit) BOOL widthToFit;

/**
 *   create CTFrameRef
 *
 */
- (void)createCTFrameRef;

/**
 *  draw
 *
 */
- (void)drawInContext:(CGContextRef)context;

/**
 *  add link to the specified place
 *
 */
- (void)addLinkWithData:(id)data
                inRange:(NSRange)range
              linkColor:(UIColor *)linkColor
         highLightColor:(UIColor *)highLightColor
         UnderLineStyle:(NSUnderlineStyle)underlineStyle;

/**
 *  replace local image with specified text
 *
 */
- (void)replaceTextWithImage:(UIImage *)image inRange:(NSRange)range;

/**
 *  replace web image with specified text
 *
 */
- (void)replaceTextWithImageURL:(NSURL *)URL inRange:(NSRange)range;


#define kTOOSTextLinkAttributedName @"TOOSTextLinkAttributedName"

@end

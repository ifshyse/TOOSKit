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
//  TOOSTextLayout.h
//  TOOSLayoutExample
//
//  Created by Stephen on 4/6/16.
//  Copyright © 2016 Stephen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@class TOOSTextAttachment;

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
 *  header color，default is RGB(0,0,0,1)
 */
@property (nonatomic,strong) UIColor* headerColor;

/**
 *  control text color，default is RGB(0,0,0,1)
 */
@property (nonatomic,strong) UIColor* controlTextColor;

/**
 *  default font is [UIFont systemFontOfSize:14.0f]
 */
@property (nonatomic,strong) UIFont* font;

/**
 *  < default is 14
 */
@property (nonatomic) CGFloat fontSize;

/**
 *  < default is 20
 */
@property (nonatomic) CGFloat headerFontSize;

/**
 *  header font
 */
@property (nonatomic,strong) UIFont* headerFont;

/**
 *  header font array
 */
@property (nonatomic,strong) NSMutableArray* headerFonts;

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
@property (nonatomic,strong) NSMutableArray* attachments;

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
 *  set text color
 *
 */
- (void)setTextWithTextColor:(UIColor*)textColor inRange:(NSRange)range;

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

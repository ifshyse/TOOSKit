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
//  TOOSTextAttribute.h
//  TOOSLayoutExample
//
//  Created by Stephen on 4/7/16.
//  Copyright © 2016 Stephen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//NS_ASSUME_NONNULL_BEGIN

#pragma mark - Enum Define


/**
 Line style in TOOSTextLayout (similar to NSUnderlineStyle).
 */
typedef NS_OPTIONS (NSInteger, TOOSTextLineStyle) {
    // basic style (bitmask:0xFF)
    TOOSTextLineStyleNone       = 0x00, ///< (        ) Do not draw a line (Default).
    TOOSTextLineStyleSingle     = 0x01, ///< (──────) Draw a single line.
    TOOSTextLineStyleThick      = 0x02, ///< (━━━━━━━) Draw a thick line.
    TOOSTextLineStyleDouble     = 0x09, ///< (══════) Draw a double line.
    
    // style pattern (bitmask:0xF00)
    TOOSTextLineStylePatternSolid      = 0x000, ///< (────────) Draw a solid line (Default).
    TOOSTextLineStylePatternDot        = 0x100, ///< (‑ ‑ ‑ ‑ ‑ ‑) Draw a line of dots.
    TOOSTextLineStylePatternDash       = 0x200, ///< (— — — —) Draw a line of dashes.
    TOOSTextLineStylePatternDashDot    = 0x300, ///< (— ‑ — ‑ — ‑) Draw a line of alternating dashes and dots.
    TOOSTextLineStylePatternDashDotDot = 0x400, ///< (— ‑ ‑ — ‑ ‑) Draw a line of alternating dashes and two dots.
    TOOSTextLineStylePatternCircleDot  = 0x900, ///< (••••••••••••) Draw a line of small circle dots.
};

#pragma mark - Enum Define

/**
 TOOSTextShadow objects are used by the NSAttributedString class cluster
 as the values for shadow attributes (stored in the attributed string under
 the key named TOOSTextShadowAttributeName or TOOSTextInnerShadowAttributeName).
 
 It's similar to `NSShadow`, but offers more options.
 */
@interface TOOSTextShadow : NSObject <NSCoding, NSCopying>
+ (instancetype)shadowWithColor:(nullable UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius;

@property (nullable, nonatomic, strong) UIColor *color; ///< shadow color
@property (nonatomic) CGSize offset;                    ///< shadow offset
@property (nonatomic) CGFloat radius;                   ///< shadow blur radius
@property (nonatomic) CGBlendMode blendMode;            ///< shadow blend mode
@property (nullable, nonatomic, strong) TOOSTextShadow *subShadow;  ///< a sub shadow which will be added above the parent shadow

+ (instancetype)shadowWithNSShadow:(NSShadow *)nsShadow; ///< convert NSShadow to TOOSTextShadow
- (NSShadow *)nsShadow; ///< convert TOOSTextShadow to NSShadow
@end

/**
 TOOSTextDecorationLine objects are used by the NSAttributedString class cluster
 as the values for decoration line attributes (stored in the attributed string under
 the key named TOOSTextUnderlineAttributeName or TOOSTextStrikethroughAttributeName).
 
 When it's used as underline, the line is drawn below text glyphs;
 when it's used as strikethrough, the line is drawn above text glyphs.
 */
@interface TOOSTextDecoration : NSObject <NSCoding, NSCopying>
+ (instancetype)decorationWithStyle:(TOOSTextLineStyle)style;
+ (instancetype)decorationWithStyle:(TOOSTextLineStyle)style width:(nullable NSNumber *)width color:(nullable UIColor *)color;
@property (nonatomic) TOOSTextLineStyle style;                   ///< line style
@property (nullable, nonatomic, strong) NSNumber *width;       ///< line width (nil means automatic width)
@property (nullable, nonatomic, strong) UIColor *color;        ///< line color (nil means automatic color)
@property (nullable, nonatomic, strong) TOOSTextShadow *shadow;  ///< line shadow
@end


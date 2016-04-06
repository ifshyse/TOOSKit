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
//  TOOSTextLayout.m
//  TOOSLayoutExample
//
//  Created by Stephen on 4/6/16.
//  Copyright © 2016 Stephen. All rights reserved.
//

#import "TOOSTextLayout.h"
#import "TOOSTextAttachment.h"

#pragma mark - Private

static CGFloat descentCallback(void *ref){
    return 0;
}

static CGFloat ascentCallback(void *ref){
    NSString* callback = (__bridge NSString *)(ref);
    NSData* jsonData = [callback dataUsingEncoding:NSUTF8StringEncoding];
    NSError* err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    return [[dic objectForKey:@"height"] floatValue];
}

static CGFloat widthCallback(void* ref){
    NSString* callback = (__bridge NSString *)(ref);
    NSData* jsonData = [callback dataUsingEncoding:NSUTF8StringEncoding];
    NSError* err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    return [[dic objectForKey:@"width"] floatValue];
}

// kCTParagraphStyleSpecifierAlignment = 0,                 //alignment property*
// kCTParagraphStyleSpecifierFirstLineHeadIndent = 1,       //first line heade indent
// kCTParagraphStyleSpecifierHeadIndent = 2,                //head indent
// kCTParagraphStyleSpecifierTailIndent = 3,                //tail indent
// kCTParagraphStyleSpecifierTabStops = 4,                  //tab stop
// kCTParagraphStyleSpecifierDefaultTabInterval = 5,        //default tab interval
// kCTParagraphStyleSpecifierLineBreakMode = 6,             //line break mode*
// kCTParagraphStyleSpecifierLineHeightMultiple = 7,        //mutiple line height
// kCTParagraphStyleSpecifierMaximumLineHeight = 8,         //max line height
// kCTParagraphStyleSpecifierMinimumLineHeight = 9,         //min line height
// kCTParagraphStyleSpecifierLineSpacing = 10,              //line space*
// kCTParagraphStyleSpecifierParagraphSpacing = 11,         //paragaraph space
// kCTParagraphStyleSpecifierParagraphSpacingBefore = 12,   //paragraph spacing before
// kCTParagraphStyleSpecifierBaseWritingDirection = 13,     //base writing direction
// kCTParagraphStyleSpecifierMaximumLineSpacing = 14,       //max line spacing
// kCTParagraphStyleSpecifierMinimumLineSpacing = 15,       //min line spacing
// kCTParagraphStyleSpecifierLineSpacingAdjustment = 16,    //line spacing adjust
// kCTParagraphStyleSpecifierCount = 17,


//ParagraphStyle

/**
 *  NSTextAlignment -> CTTextAlignment
 *
 */
static CTTextAlignment _coreTextAlignmentFromNSTextAlignment(NSTextAlignment alignment) {
    switch (alignment) {
        case NSTextAlignmentLeft: return kCTTextAlignmentLeft;
        case NSTextAlignmentCenter: return kCTTextAlignmentCenter;
        case NSTextAlignmentRight: return kCTTextAlignmentRight;
        case NSTextAlignmentJustified : return kCTTextAlignmentJustified;
        case NSTextAlignmentNatural: return kCTTextAlignmentNatural;
        default: return kCTTextAlignmentLeft;
    }
}

// kCTLineBreakByWordWrapping = 0,        
// kCTLineBreakByCharWrapping = 1,
// kCTLineBreakByClipping = 2,
// kCTLineBreakByTruncatingHead = 3,
// kCTLineBreakByTruncatingTail = 4,
// kCTLineBreakByTruncatingMiddle = 5

/**
 *   NSLineBreakMode -> CTLineBreakMode
 *
 */
static CTLineBreakMode _coreTextLineBreakModeFromNSLineBreakModel(NSLineBreakMode lineBreakMode) {
    switch (lineBreakMode) {
        case NSLineBreakByWordWrapping: return kCTLineBreakByWordWrapping;
        case NSLineBreakByCharWrapping: return kCTLineBreakByCharWrapping;
        case NSLineBreakByClipping: return kCTLineBreakByClipping;
        case NSLineBreakByTruncatingHead: return kCTLineBreakByTruncatingHead;
        case NSLineBreakByTruncatingTail: return kCTLineBreakByTruncatingTail;
        case NSLineBreakByTruncatingMiddle: return kCTLineBreakByTruncatingMiddle;
    }
}

//NSUnderlineStyleNone = 0x00,
//NSUnderlineStyleSingle = 0x01,
//NSUnderlineStyleThick NS_ENUM_AVAILABLE(10_0, 7_0) = 0x02,
//NSUnderlineStyleDouble NS_ENUM_AVAILABLE(10_0, 7_0) = 0x09,
//NSUnderlinePatternSolid NS_ENUM_AVAILABLE(10_0, 7_0) = 0x0000,
//NSUnderlinePatternDot NS_ENUM_AVAILABLE(10_0, 7_0) = 0x0100,
//NSUnderlinePatternDash NS_ENUM_AVAILABLE(10_0, 7_0) = 0x0200,
//NSUnderlinePatternDashDot NS_ENUM_AVAILABLE(10_0, 7_0) = 0x0300,
//NSUnderlinePatternDashDotDot NS_ENUM_AVAILABLE(10_0, 7_0) = 0x0400,
//NSUnderlineByWord NS_ENUM_AVAILABLE(10_0, 7_0) = 0x8000

/**
 *   NSUnderlineStyle -> CTUnderlineStyle
 *
 */

static CTUnderlineStyle _coreTextUnderlineStyleFromNSUnderlineStyle(NSUnderlineStyle underlineStyle) {
    switch (underlineStyle) {
        case NSUnderlineStyleNone: return kCTUnderlineStyleNone;
        case NSUnderlineStyleSingle: return kCTUnderlineStyleSingle;
        case NSUnderlineStyleThick: return kCTUnderlineStyleThick;
        default:return kCTUnderlineStyleNone;
    }
}

@implementation TOOSTextLayout

#pragma mark - init

- (id)init {
    if (self = [super init]) {
        self.text = nil;
        self.attributedText = nil;
        self.textColor = [UIColor blackColor];
        self.fontSize = 14.0f;
        self.headerFontSize = 20.0f;
        self.font = [UIFont systemFontOfSize:self.fontSize];
        self.linkColor = [UIColor blueColor];
        self.highlightColor = [UIColor lightGrayColor];
        self.headerColor = [UIColor colorWithRed:0.558 green:1.000 blue:0.502 alpha:1.000];
        self.controlTextColor = [UIColor colorWithWhite:0.604 alpha:1.000];
        self.textAlignment = NSTextAlignmentLeft;
        self.veriticalAlignment = TOOSVerticalAlignmentCenter;
        self.lineBreakMode = NSLineBreakByWordWrapping;
        self.boundsRect = CGRectZero;
        self.linespace = 2.0f;
        self.characterSpacing = 1.0f;
        self.underlineStyle = NSUnderlineStyleNone;
        self.widthToFit = YES;
        self.headerFont = [UIFont systemFontOfSize:20.0f];
        self.headerFonts = [[NSMutableArray alloc] init];
        for (int i = 0; i < 6; i++) {
            CGFloat size =  - (self.headerFontSize - self.fontSize) / 5.0 * i;
            [self.headerFonts addObject:[UIFont systemFontOfSize:size]];
        }
    }
    return self;
}

- (NSUInteger)hash {
    NSUInteger value = 0;
    value ^= [_attributedText hash];
    return value;
}

- (void)createCTFrameRef {
    if (_attributedText == nil) {
        return;
    }
    if (_textHeight > 0) {
        return;
    }
    CTFramesetterRef ctFrameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attributedText);
    CGSize suggestSize = CTFramesetterSuggestFrameSizeWithConstraints(ctFrameSetter,
                                                                      CFRangeMake(0, _attributedText.length),
                                                                      NULL,
                                                                      CGSizeMake(self.boundsRect.size.width, CGFLOAT_MAX),
                                                                      NULL);
    _textHeight = suggestSize.height;
    _textWidth = suggestSize.width;
    if (self.isWidthToFit) {
        self.boundsRect = CGRectMake(self.boundsRect.origin.x, self.boundsRect.origin.y, suggestSize.width, suggestSize.height);
    } else {
        self.boundsRect = CGRectMake(self.boundsRect.origin.x, self.boundsRect.origin.y, self.boundsRect.size.width, suggestSize.height);
    }
    CGMutablePathRef textPath = CGPathCreateMutable();
    CGPathAddRect(textPath, NULL, self.boundsRect);
    _frame = CTFramesetterCreateFrame(ctFrameSetter, CFRangeMake(0, 0), textPath, NULL);
    CFRelease(ctFrameSetter);
    CFRelease(textPath);
}

#pragma mark - draw
- (void)drawInContext:(CGContextRef)context {
    @autoreleasepool {
        CGContextSaveGState(context);
        CGContextSetTextMatrix(context,CGAffineTransformIdentity);
        CGContextTranslateCTM(context, self.boundsRect.origin.x, self.boundsRect.origin.y);
        CGContextTranslateCTM(context, 0, self.boundsRect.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextTranslateCTM(context, - self.boundsRect.origin.x, -self.boundsRect.origin.y);
        CTFrameDraw(self.frame, context);
        CGContextRestoreGState(context);
        if (self.attachments.count == 0) {
            return;
        }
        for (NSInteger i = 0; i < self.attachments.count; i ++) {
            TOOSTextAttachment* attachment = self.attachments[i];
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, self.boundsRect.origin.x, self.boundsRect.origin.y);
            CGContextTranslateCTM(context, 0, self.boundsRect.size.height);
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextTranslateCTM(context, - self.boundsRect.origin.x, -self.boundsRect.origin.y);
            CGContextDrawImage(context,attachment.imgRect, attachment.image.CGImage);
            CGContextRestoreGState(context);
        }
    }
}

#pragma mark - Add Link

- (void)addLinkWithData:(id)data
                inRange:(NSRange)range
              linkColor:(UIColor *)linkColor
         highLightColor:(UIColor *)highLightColor
         UnderLineStyle:(NSUnderlineStyle)underlineStyle {
    if (_attributedText == nil || _attributedText.length == 0) {
        return;
    }
    [self _resetFrameRef];
    if (linkColor != nil) {
        [self _mutableAttributedString:_attributedText addAttributesWithTextColor:linkColor
                               inRange:range];
    }
    if (underlineStyle != NSUnderlineStyleNone) {
        [self _mutableAttributedString:_attributedText addAttributesWithUnderlineStyle:underlineStyle
                               inRange:range];
    }
    if (data != nil) {
        [self _mutableAttributedString:_attributedText addLinkAttributesNameWithValue:data inRange:range];
    }
    [self createCTFrameRef];
}

- (void)setTextWithTextColor:(UIColor*)textColor inRange:(NSRange)range  {
    if (_attributedText == nil || _attributedText.length == 0) {
        return;
    }
    [self _resetFrameRef];
    [self _mutableAttributedString:_attributedText addAttributesWithTextColor:textColor
                           inRange:range];
    [self createCTFrameRef];
}

#pragma mark - Add Image

- (void)replaceTextWithImage:(UIImage *)image
                     inRange:(NSRange)range {
    if (_attributedText == nil || _attributedText.length == 0) {
        return;
    }
    [self _resetFrameRef];
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    NSAttributedString* placeholder = [self _placeHolderStringWithJson:[self _jsonWithImageWith:width
                                                                                    imageHeight:height]];
    [_attributedText replaceCharactersInRange:range withAttributedString:placeholder];
    [self createCTFrameRef];
    TOOSTextAttachment* attachment = [[TOOSTextAttachment alloc] init];
    attachment.image = image;
    [self _setupImageAttachPositionWithAttach:attachment];
    [self.attachments addObject:attachment];
}

- (void)replaceTextWithImageURL:(NSURL *)URL inRange:(NSRange)range {
    if (_attributedText == nil || _attributedText.length == 0) {
        return;
    }
    if (!URL) {
        return;
    }
    
}

- (void)_setupImageAttachPositionWithAttach:(TOOSTextAttachment *)attachment {
    NSArray* lines = (NSArray *)CTFrameGetLines(_frame);
    NSUInteger lineCount = [lines count];
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(_frame, CFRangeMake(0, 0), lineOrigins);
    for (int i = 0; i < lineCount; i++) {
        if (attachment == nil) {
            break;
        }
        CTLineRef line = (__bridge CTLineRef)lines[i];
        NSArray* runObjArray = (NSArray *)CTLineGetGlyphRuns(line);
        for (id runObj in runObjArray) {
            CTRunRef run = (__bridge CTRunRef)runObj;
            NSDictionary* runAttributes = (NSDictionary *)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runAttributes valueForKey:(id)kCTRunDelegateAttributeName];
            if (delegate == nil) {
                continue;
            }
            
            CGRect runBounds;
            CGFloat ascent;
            CGFloat descent;
            runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
            runBounds.size.height = ascent + descent;
            
            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            runBounds.origin.x = lineOrigins[i].x + xOffset;
            runBounds.origin.y = lineOrigins[i].y - descent;
            
            CGPathRef pathRef = CTFrameGetPath(_frame);
            CGRect colRect = CGPathGetBoundingBox(pathRef);
            CGRect delegateRect = CGRectMake(runBounds.origin.x + colRect.origin.x,
                                             runBounds.origin.y + colRect.origin.y,
                                             runBounds.size.width,
                                             runBounds.size.height);
            attachment.imgRect = delegateRect;
        }
    }
}

- (NSString *)_jsonWithImageWith:(CGFloat)width
                     imageHeight:(CGFloat)height {
    NSString* jsonString = [NSString stringWithFormat:@"{\"width\":\"%f\",\"height\":\"%f\"}",width,height];
    return jsonString;
}

- (NSAttributedString *)_placeHolderStringWithJson:(NSString *)json {
    CTRunDelegateCallbacks callbacks;
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = ascentCallback;
    callbacks.getDescent = descentCallback;
    callbacks.getWidth = widthCallback;
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)(json));
    unichar objectReplacementChar = 0xFFFC;
    NSString* content = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSMutableAttributedString* space = [[NSMutableAttributedString alloc] initWithString:content];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, content.length),
                                   kCTRunDelegateAttributeName, delegate);
    CFRelease(delegate);
    return space;
}


#pragma mark - Reset
- (void)_resetAttachments {
    [self.attachments removeAllObjects];
}

- (void)_resetFrameRef {
    if (_frame) {
        CFRelease(_frame);
        _frame = nil;
    }
    _textHeight = 0;
}

#pragma mark - Getter

- (NSMutableArray *)attachments {
    if (!_attachments) {
        _attachments = [[NSMutableArray alloc] init];
    }
    return _attachments;
}

- (NSString *)text {
    return _attributedText.string;
}

#pragma mark - Setter

- (void)setText:(NSString *)text {
    [self _resetAttachments];
    [self _resetFrameRef];
    _attributedText = [self _createAttributedStringWithText:text];
    
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [self _resetAttachments];
    [self _resetFrameRef];
    if (attributedText == nil) {
        _attributedText = [[NSMutableAttributedString alloc]init];
    }else if ([attributedText isKindOfClass:[NSMutableAttributedString class]]) {
        _attributedText = (NSMutableAttributedString *)attributedText;
    }else {
        _attributedText = [[NSMutableAttributedString alloc]initWithAttributedString:attributedText];
    }
    [self createCTFrameRef];
}

- (void)setTextColor:(UIColor *)textColor {
    if (textColor && _textColor != textColor){
        _textColor = textColor;
        [self _mutableAttributedString:_attributedText
            addAttributesWithTextColor:_textColor
                               inRange:NSMakeRange(0, _attributedText.length)];
        [self _resetFrameRef];
    }
}

- (void)setFont:(UIFont *)font {
    if (font && _font != font){
        _font = font;
        [self _mutableAttributedString:_attributedText
                 addAttributesWithFont:_font
                               inRange:NSMakeRange(0, _attributedText.length)];
        [self _resetFrameRef];
    }
}

- (void)setCharacterSpacing:(unichar)characterSpacing {
    if (characterSpacing >= 0 && _characterSpacing != characterSpacing) {
        _characterSpacing = characterSpacing;
        [self _mutableAttributedString:_attributedText
     addAttributesWithCharacterSpacing:characterSpacing
                               inRange:NSMakeRange(0, _attributedText.length)];
        [self _resetFrameRef];
    }
}

- (void)setLinespace:(CGFloat)linespace {
    if (_linespace != linespace) {
        _linespace = linespace;
        [self _mutableAttributedString:_attributedText
          addAttributesWithLineSpacing:_linespace
                         textAlignment:_textAlignment
                         lineBreakMode:_lineBreakMode
                               inRange:NSMakeRange(0, _attributedText.length)];
        [self _resetFrameRef];
    }
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    if (_textAlignment != textAlignment) {
        _textAlignment = textAlignment;
        self.widthToFit = NO;
        [self _mutableAttributedString:_attributedText
          addAttributesWithLineSpacing:_linespace
                         textAlignment:_textAlignment
                         lineBreakMode:_lineBreakMode
                               inRange:NSMakeRange(0, _attributedText.length)];
        [self _resetFrameRef];
    }
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    if (_lineBreakMode != lineBreakMode) {
        _lineBreakMode = lineBreakMode;
        [self _mutableAttributedString:_attributedText
          addAttributesWithLineSpacing:_linespace
                         textAlignment:_textAlignment
                         lineBreakMode:_lineBreakMode
                               inRange:NSMakeRange(0, _attributedText.length)];
        [self _resetFrameRef];
    }
}

- (void)dealloc {
    if (self.frame) {
        CFRelease(self.frame);
    }
}

#pragma mark - Attributes

/**
 *  create attributed string
 *
 */
- (NSMutableAttributedString *)_createAttributedStringWithText:(NSString *)text {
    if (text.length <= 0) {
        return [[NSMutableAttributedString alloc]init];
    }
    NSMutableAttributedString* attbutedString = [[NSMutableAttributedString alloc] initWithString:text];
    [self _mutableAttributedString:attbutedString
        addAttributesWithTextColor:_textColor
                           inRange:NSMakeRange(0, text.length)];
    [self _mutableAttributedString:attbutedString
             addAttributesWithFont:_font
                           inRange:NSMakeRange(0, text.length)];
    [self _mutableAttributedString:attbutedString addAttributesWithLineSpacing:_linespace
                     textAlignment:_textAlignment
                     lineBreakMode:_lineBreakMode
                           inRange:NSMakeRange(0, text.length)];
    [self _mutableAttributedString:attbutedString addAttributesWithUnderlineStyle:_underlineStyle
                           inRange:NSMakeRange(0, text.length)];
    return attbutedString;
}


/**
 *  add link
 *
 */

- (void)_mutableAttributedString:(NSMutableAttributedString *)attributedString
  addLinkAttributesNameWithValue:(id)value
                         inRange:(NSRange)range {
    
    if (attributedString == nil) {
        return;
    }
    if (value != nil) {
        [attributedString addAttribute:kTOOSTextLinkAttributedName
                                 value:value
                                 range:range];
    }
}

/**
 *  add underline
 *
 */
- (void)_mutableAttributedString:(NSMutableAttributedString *)attributedString
 addAttributesWithUnderlineStyle:(NSUnderlineStyle)underlineStyle
                         inRange:(NSRange)range {
    if (attributedString == nil) {
        return;
    }
    [attributedString removeAttribute:(NSString *)kCTUnderlineStyleAttributeName range:range];
    CTUnderlineStyle ctUnderlineStyle = _coreTextUnderlineStyleFromNSUnderlineStyle(underlineStyle);
    if (ctUnderlineStyle != kCTUnderlineStyleNone) {
        [attributedString addAttribute:(NSString *)kCTUnderlineStyleAttributeName
                                 value:[NSNumber numberWithInt:(ctUnderlineStyle)]
                                 range:range];
    }
}

/**
 *  add text setting
 *
 */
- (void)_mutableAttributedString:(NSMutableAttributedString *)attributedString
    addAttributesWithLineSpacing:(CGFloat)linespacing
                   textAlignment:(NSTextAlignment)textAlignment
                   lineBreakMode:(NSLineBreakMode)lineBreakMode
                         inRange:(NSRange)range {
    if (attributedString == nil) {
        return;
    }
    [attributedString removeAttribute:(NSString *)kCTParagraphStyleAttributeName
                                range:range];
    CTTextAlignment ctTextAlignment = _coreTextAlignmentFromNSTextAlignment(textAlignment);
    CTLineBreakMode ctLineBreakMode = _coreTextLineBreakModeFromNSLineBreakModel(lineBreakMode);
    CTParagraphStyleSetting theSettings[] = {
        { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &linespacing},
        { kCTParagraphStyleSpecifierAlignment, sizeof(ctTextAlignment), &ctTextAlignment },
        { kCTParagraphStyleSpecifierLineBreakMode,sizeof(CTLineBreakMode),&ctLineBreakMode }
    };
    CTParagraphStyleRef paragraphRef = CTParagraphStyleCreate(theSettings, sizeof(theSettings) / sizeof(theSettings[0]));
    if (paragraphRef != nil) {
        [attributedString addAttribute:(id)kCTParagraphStyleAttributeName value:(__bridge id)paragraphRef range:range];
        CFRelease(paragraphRef);
    }
}

/**
 * add text font
 *
 */
- (void)_mutableAttributedString:(NSMutableAttributedString *)attributedString
           addAttributesWithFont:(UIFont *)font
                         inRange:(NSRange)range {
    if (attributedString == nil || font == nil) {
        return;
    }
    [attributedString removeAttribute:(NSString *)kCTFontAttributeName range:range];
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, nil);
    if (fontRef != nil) {
        [attributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:range];
        CFRelease(fontRef);
    }
}

/**
 *  add text color
 *
 */
- (void)_mutableAttributedString:(NSMutableAttributedString *)attributedString
      addAttributesWithTextColor:(UIColor *)textColor
                         inRange:(NSRange)range {
    if (attributedString == nil || textColor == nil) {
        return;
    }
    [attributedString removeAttribute:(NSString *)kCTForegroundColorAttributeName range:range];
    [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)textColor.CGColor range:range];
}


/**
 *  add text cap
 *
 */
- (void)_mutableAttributedString:(NSMutableAttributedString *)attributedString
addAttributesWithCharacterSpacing:(unichar)characterSpacing
                         inRange:(NSRange)range {
    if (attributedString == nil) {
        return;
    }
    [attributedString removeAttribute:(NSString *)kCTKernAttributeName range:range];
    
    CFNumberRef charSpacingNum =  CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&characterSpacing);
    if (charSpacingNum != nil) {
        [attributedString addAttribute:(NSString *)kCTKernAttributeName value:(__bridge id)charSpacingNum range:range];
        CFRelease(charSpacingNum);
    }
}

@end

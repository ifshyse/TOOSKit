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
//  TOOSTextParser.m
//  TOOSLayoutExample
//
//  Created by Stephen on 4/6/16.
//  Copyright © 2016 Stephen. All rights reserved.
//

#import "TOOSTextParser.h"
#import "TOOSTextLayout.h"

#define URL_REGULAR_EX      @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"
#define EMOJI_REGULAR_EX    @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]"
#define ACCOUNT_REGULAR_EX  @"@[\u4e00-\u9fa5a-zA-Z0-9_-]{2,30}"
#define TOPIC_REGULAR_EX    @"#[^#]+#"
#define HEADER_REGULAR_EX   @"^((\\#{1,6}[^#].*)|(\\#{6}.+))$"
#define H1_REGULAR_EX       @"^[^=\\n][^\\n]*\\n=+$"
#define H2_REGULAR_EX       @"^[^-\\n][^\\n]*\\n-+$"

static NSRegularExpression* _HeaderRegularExpression = nil;
static NSRegularExpression* _EmojiRegularExpression = nil;
static NSRegularExpression* _URLRegularExpression = nil;
static NSRegularExpression* _AccountRegularExpression = nil;
static NSRegularExpression* _TopicRegularExpression = nil;
static NSRegularExpression* _H1RegularExpression = nil;
static NSRegularExpression* _H2RegularExpression = nil;

#define REGULAR_EXPRESSION(expression, name) \
__block NSRegularExpression* exp = expression; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
    exp = [[NSRegularExpression alloc] initWithPattern:name options:NSRegularExpressionAnchorsMatchLines error:nil]; \
}); \
return exp; \

static inline NSRegularExpression* HeaderRegularExpression() {
    REGULAR_EXPRESSION(_HeaderRegularExpression, HEADER_REGULAR_EX);
}

static inline NSRegularExpression* EmojiRegularExpression() {
    REGULAR_EXPRESSION(_EmojiRegularExpression, EMOJI_REGULAR_EX);
}

static inline NSRegularExpression* URLRegularExpression() {
    REGULAR_EXPRESSION(_URLRegularExpression, URL_REGULAR_EX);
}

static inline NSRegularExpression* AccountRegularExpression() {
    REGULAR_EXPRESSION(_AccountRegularExpression, ACCOUNT_REGULAR_EX);
}

static inline NSRegularExpression* TopicRegularExpression() {
    REGULAR_EXPRESSION(_TopicRegularExpression, TOPIC_REGULAR_EX);
}

static inline NSRegularExpression* H1RegularExpression() {
    REGULAR_EXPRESSION(_H1RegularExpression, H1_REGULAR_EX);
}

static inline NSRegularExpression* H2RegularExpression() {
    REGULAR_EXPRESSION(_H2RegularExpression, H2_REGULAR_EX);
}

@implementation TOOSTextParser

+ (void)parseWithTextLayout:(TOOSTextLayout *)textLayout {
    
    NSString* text = textLayout.text;
    if (text.length == 0) {
        return;
    }
    
    NSArray* header = [TOOSTextParser textLayoutContain:textLayout regularExpression:HeaderRegularExpression()];
    if (header.count > 0) {
        [header enumerateObjectsUsingBlock:^(NSTextCheckingResult *result, NSUInteger idx, BOOL *stop) {
            NSRange r = result.range;
            NSUInteger whiteLen = [TOOSTextParser lenghOfBeginWhiteInString:text withRange:r];
            NSUInteger sharpLen = [TOOSTextParser lenghOfBeginChar:'#' inString:text withRange:NSMakeRange(r.location + whiteLen, r.length - whiteLen)];
            if (sharpLen > 6) sharpLen = 6;
            [textLayout setTextWithTextColor:textLayout.controlTextColor inRange:NSMakeRange(r.location, whiteLen + sharpLen)];
            [textLayout setTextWithTextColor:textLayout.headerColor inRange:NSMakeRange(r.location + whiteLen + sharpLen, r.length - whiteLen - sharpLen)];
            [textLayout.attributedText addAttribute:textLayout.headerFont.fontName value:textLayout.headerFonts[sharpLen - 1] range:result.range];
        }];
    }
    
    NSArray* header1 = [TOOSTextParser textLayoutContain:textLayout regularExpression:H1RegularExpression()];
    if (header1.count > 0) {
        [header1 enumerateObjectsUsingBlock:^(NSTextCheckingResult *result, NSUInteger idx, BOOL *stop) {
            NSRange r = result.range;
            NSRange linebreak = [text rangeOfString:@"\n" options:0 range:result.range locale:nil];
            if (linebreak.location != NSNotFound) {
            [textLayout setTextWithTextColor:textLayout.headerColor inRange:NSMakeRange(r.location, linebreak.location - r.location)];
            [textLayout.attributedText addAttribute:textLayout.headerFont.fontName value:textLayout.headerFonts[0] range:result.range];
             [textLayout setTextWithTextColor:textLayout.controlTextColor inRange:NSMakeRange(linebreak.location + linebreak.length, r.location + r.length - linebreak.location - linebreak.length)];
            }
        }];
    }
    
    NSArray* header2 = [TOOSTextParser textLayoutContain:textLayout regularExpression:H2RegularExpression()];
    if (header2.count > 0) {
        [header2 enumerateObjectsUsingBlock:^(NSTextCheckingResult *result, NSUInteger idx, BOOL *stop) {
            NSRange r = result.range;
            NSRange linebreak = [text rangeOfString:@"\n" options:0 range:result.range locale:nil];
            if (linebreak.location != NSNotFound) {
                [textLayout setTextWithTextColor:textLayout.headerColor inRange:NSMakeRange(r.location, linebreak.location - r.location)];
                [textLayout.attributedText addAttribute:textLayout.headerFont.fontName value:textLayout.headerFonts[1] range:NSMakeRange(r.location, linebreak.location - r.location + 1)];
                [textLayout setTextWithTextColor:textLayout.controlTextColor inRange:NSMakeRange(linebreak.location + linebreak.length, r.location + r.length - linebreak.location - linebreak.length)];
            }
        }];
    }
    
    NSArray* emoji = [TOOSTextParser textLayoutContain:textLayout regularExpression:EmojiRegularExpression()];
    if (emoji.count > 0) {
        [emoji enumerateObjectsUsingBlock:^(NSTextCheckingResult *result, NSUInteger idx, BOOL *stop) {
            NSRange range = [result range];
            NSString* content = [text substringWithRange:range];
            if (textLayout.text.length >= range.location + range.length) {
                [textLayout replaceTextWithImage:[UIImage imageNamed:content] inRange:range];
            }
        }];
    }
    
    NSArray* httpURL = [TOOSTextParser textLayoutContain:textLayout regularExpression:URLRegularExpression()];
    if (httpURL.count > 0) {
        [httpURL enumerateObjectsUsingBlock:^(NSTextCheckingResult *result, NSUInteger idx, BOOL *stop) {
            NSRange range = [result range];
            NSString* content = [text substringWithRange:range];
            [textLayout addLinkWithData:content
                                inRange:range
                              linkColor:textLayout.linkColor
                         highLightColor:textLayout.highlightColor
                         UnderLineStyle:NSUnderlineStyleSingle];
        }];
    }
    
    NSArray* account = [TOOSTextParser textLayoutContain:textLayout regularExpression:AccountRegularExpression()];
    if (account.count > 0) {
        [account enumerateObjectsUsingBlock:^(NSTextCheckingResult *result, NSUInteger idx, BOOL *stop) {
            NSRange range = [result range];
            NSString* content = [text substringWithRange:range];
            [textLayout addLinkWithData:content
                                inRange:range
                              linkColor:textLayout.linkColor
                         highLightColor:textLayout.highlightColor
                         UnderLineStyle:underline];
        }];
    }
    
    NSArray* topic = [TOOSTextParser textLayoutContain:textLayout regularExpression:TopicRegularExpression()];
    if (topic.count > 0) {
        [topic enumerateObjectsUsingBlock:^(NSTextCheckingResult *result, NSUInteger idx, BOOL *stop) {
            NSRange range = [result range];
            NSString* content = [text substringWithRange:range];
            [textLayout addLinkWithData:content
                                inRange:range
                              linkColor:textLayout.linkColor
                         highLightColor:textLayout.highlightColor
                         UnderLineStyle:textLayout.underlineStyle];
        }];
    }
}

+ (NSUInteger)lenghOfBeginWhiteInString:(NSString *)str withRange:(NSRange)range{
    for (NSUInteger i = 0; i < range.length; i++) {
        unichar c = [str characterAtIndex:i + range.location];
        if (c != ' ' && c != '\t' && c != '\n') return i;
    }
    return str.length;
}

+ (NSUInteger)lenghOfEndWhiteInString:(NSString *)str withRange:(NSRange)range{
    for (NSInteger i = range.length - 1; i >= 0; i--) {
        unichar c = [str characterAtIndex:i + range.location];
        if (c != ' ' && c != '\t' && c != '\n') return range.length - i;
    }
    return str.length;
}

+ (NSUInteger)lenghOfBeginChar:(unichar)c inString:(NSString *)str withRange:(NSRange)range{
    for (NSUInteger i = 0; i < range.length; i++) {
        if ([str characterAtIndex:i + range.location] != c) return i;
    }
    return str.length;
}

+ (NSArray*)textLayoutContain:(TOOSTextLayout *)textLayout regularExpression:(NSRegularExpression*)regularExpression {
    NSString* text = textLayout.text;
    NSArray* resultArray = [regularExpression matchesInString:text
                                                             options:0
                                                               range:NSMakeRange(0,text.length)];
    return resultArray;
}

@end

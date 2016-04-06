//
//  TOOSTextParser.m
//  TOOSLayoutExample
//
//  Created by Stephen on 4/6/16.
//  Copyright © 2016 Stephen. All rights reserved.
//

#import "TOOSTextParser.h"

#define URL_REGULAR_EX      @""
#define EMOJI_REGULAR_EX    @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]"
#define ACCOUNT_REGULAR_EX  @"@[\u4e00-\u9fa5a-zA-Z0-9_-]{2,30}"
#define TOPIC_REGULAR_EX    @"#[^#]+#"

static NSRegularExpression* _EmojiRegularExpression = nil;
static NSRegularExpression* _URLRegularExpression = nil;
static NSRegularExpression* _AccountRegularExpression = nil;
static NSRegularExpression* _TopicRegularExpression = nil;

#define REGULAR_EXPRESSION(expression, name) \
__block NSRegularExpression* exp = expression; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
    exp = [[NSRegularExpression alloc] initWithPattern:name options:NSRegularExpressionAnchorsMatchLines error:nil]; \
}); \
return exp; \

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

@implementation TOOSTextParser

+ (void)parseWithTextLayout:(TOOSTextLayout *)textLayout {
    
    NSString* text = textLayout.text;
    NSArray* emoji = [TOOSTextParser textLayoutContain:textLayout regularExpression:EmojiRegularExpression()];
    for(NSTextCheckingResult* match in emoji) {
        NSRange range = [match range];
        NSString* content = [text substringWithRange:range];
        if (textLayout.text.length >= range.location + range.length) {
            [textLayout replaceTextWithImage:[UIImage imageNamed:content] inRange:range];
        }
    }
    NSArray* httpURL = [TOOSTextParser textLayoutContain:textLayout regularExpression:URLRegularExpression()];
    for(NSTextCheckingResult* match in httpURL) {
        NSRange range = [match range];
        NSString* content = [text substringWithRange:range];
        [textLayout addLinkWithData:content
                            inRange:range
                          linkColor:textLayout.linkColor
                     highLightColor:textLayout.highlightColor
                     UnderLineStyle:NSUnderlineStyleSingle];
    }
    NSArray* account = [TOOSTextParser textLayoutContain:textLayout regularExpression:AccountRegularExpression()];
    for(NSTextCheckingResult* match in account) {
        NSRange range = [match range];
        NSString* content = [text substringWithRange:range];
        [textLayout addLinkWithData:content
                            inRange:range
                          linkColor:textLayout.linkColor
                     highLightColor:textLayout.highlightColor
                     UnderLineStyle:underline];
    }
    NSArray* topic = [TOOSTextParser textLayoutContain:textLayout regularExpression:TopicRegularExpression()];
    for(NSTextCheckingResult* match in topic) {
        NSRange range = [match range];
        NSString* content = [text substringWithRange:range];
        [textLayout addLinkWithData:content
                            inRange:range
                          linkColor:textLayout.linkColor
                     highLightColor:textLayout.highlightColor
                     UnderLineStyle:textLayout.underlineStyle];
    }
}

+ (NSArray*)textLayoutContain:(TOOSTextLayout *)textLayout regularExpression:(NSRegularExpression*)regularExpression {
    NSString* text = textLayout.text;
    NSArray* resultArray = [regularExpression matchesInString:text
                                                             options:0
                                                               range:NSMakeRange(0,text.length)];
    return resultArray;
}

@end

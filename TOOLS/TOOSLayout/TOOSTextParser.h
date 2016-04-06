//
//  TOOSTextParser.h
//  TOOSLayoutExample
//
//  Created by Stephen on 4/6/16.
//  Copyright © 2016 Stephen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TOOSTextLayout.h"

@interface TOOSTextParser : NSObject

/**
 *  parse text layout
 */
+ (void)parseWithTextLayout:(TOOSTextLayout *)textLayout;

/**
 *  return regular expression contained array
 */
+ (NSArray*)textLayoutContain:(TOOSTextLayout *)textLayout regularExpression:(NSRegularExpression*)regularExpression;

@end

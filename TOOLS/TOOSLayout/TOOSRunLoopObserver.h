//
//  TOOSRunLoopObserver.h
//  TOOSLayoutExample
//
//  Created by Stephen on 4/6/16.
//  Copyright © 2016 Stephen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TOOSRunLoopObserver : NSObject

/**
 *  initial observer instance
 */
+ (TOOSRunLoopObserver *)observerWithTarget:(id)target
                                   selector:(SEL)selector
                                     object:(id)object;

/**
 *  commit observer
 */
- (void)commit;

@end

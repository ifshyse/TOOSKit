//
//  CALayer+TOOSExtension.m
//  TOOSLayoutExample
//
//  Created by Stephen on 4/6/16.
//  Copyright © 2016 Stephen. All rights reserved.
//

#import "CALayer+TOOSExtension.h"
#import "TOOSRunLoopObserver.h"

@implementation CALayer(TOOSExtension)

- (void)toos_setContents:(id)contents
{
    TOOSRunLoopObserver* obeserver = [TOOSRunLoopObserver observerWithTarget:self
                                                                selector:@selector(setContents:)
                                                                  object:contents];
    [obeserver commit];
}

@end

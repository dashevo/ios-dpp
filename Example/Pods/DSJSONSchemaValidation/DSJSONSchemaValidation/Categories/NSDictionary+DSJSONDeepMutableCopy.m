//
//  NSDictionary+DSJSONDeepMutableCopy.m
//  libDSJSONSchemaValidation-iOS
//
//  Created by Andrew Podkovyrin on 07/09/2018.
//  Copyright © 2018 Dash Core Group. All rights reserved.
//

#import "NSDictionary+DSJSONDeepMutableCopy.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSDictionary (DSJSONDeepMutableCopy)

- (NSMutableDictionary *)ds_deepMutableCopy
{
    NSMutableDictionary *mutableCopy = (NSMutableDictionary *)CFBridgingRelease(CFPropertyListCreateDeepCopy(kCFAllocatorDefault, (CFDictionaryRef)self, kCFPropertyListMutableContainers));
    return mutableCopy;
}

@end

NS_ASSUME_NONNULL_END

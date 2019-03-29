//
//  Created by Andrew Podkovyrin
//  Copyright © 2018 Dash Core Group. All rights reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  https://opensource.org/licenses/MIT
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "DPSchemaHashUtils.h"

#import "NSData+DPSchemaUtils.h"
#import <TinyCborObjc/NSObject+DSCborEncoding.h>

NS_ASSUME_NONNULL_BEGIN

@implementation DPSchemaHashUtils

+ (nullable NSData *)serializeObject:(NSObject *)object {
    return [object ds_cborEncodedObject];
}

+ (nullable NSData *)hashOfSerializedObject:(NSData *)data {
    NSData *sha256Twice = [[data dp_SHA256Digest] dp_SHA256Digest];
    NSData *sha256Reversed = [sha256Twice dp_reverseData];
    
    return sha256Reversed;
}

+ (nullable NSData *)hashOfObject:(NSObject *)object {
    NSData *data = [self serializeObject:object];
    if (!data) {
        return nil;
    }
    
    return [self hashOfSerializedObject:data];
}

+ (nullable NSString *)hashStringOfObject:(NSObject *)object {
    NSData *hash = [self hashOfObject:object];
    if (!hash) {
        return nil;
    }

    NSString *sha256String = [hash ds_hexStringFromData];

    return sha256String;
}

@end

NS_ASSUME_NONNULL_END
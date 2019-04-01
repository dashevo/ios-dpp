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

#import "DPSerializeUtils.h"

#import <TinyCborObjc/NSData+DSCborDecoding.h>
#import <TinyCborObjc/NSObject+DSCborEncoding.h>

#import "NSData+DPSchemaUtils.h"

NS_ASSUME_NONNULL_BEGIN

static _Nullable id DecodeCborData(NSData *data, size_t outBufferSize, NSError *_Nullable __autoreleasing *error) {
    const size_t MAX_BUFFER_SIZE = 1024 * 1024 * 4; // 4 Mb

    NSError *decodingError = nil;
    id decoded = [data ds_decodeCborWithOutBufferSize:outBufferSize error:&decodingError];
    if ([decodingError.domain isEqualToString:DSTinyCborDecodingErrorDomain] &&
        decodingError.code == 4 /* CborErrorIO */ &&
        outBufferSize <= MAX_BUFFER_SIZE) {
        return DecodeCborData(data, outBufferSize * 2, error);
    }

    if (error != NULL) {
        *error = decodingError;
    }

    return decoded;
}

@implementation DPSerializeUtils

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

+ (nullable id)decodeSerializedObject:(NSData *)data error:(NSError *_Nullable __autoreleasing *)error {
    const size_t START_BUFFER_SIZE = 1024; // 1 Kb
    return DecodeCborData(data, START_BUFFER_SIZE, error);
}

@end

NS_ASSUME_NONNULL_END

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

#import "DSSchemaObject.h"

#import <DSJSONSchemaValidation/NSDictionary+DSJSONDeepMutableCopy.h>

#import "DSJsonSchemaUtils.h"
#import "DSSchemaHash.h"
#import "DSSchemaStorage.h"

NS_ASSUME_NONNULL_BEGIN

NSString *const DS_ACT = @"act";
NSString *const DS_ALL_OF = @"allOf";
NSString *const DS_DAPOBJECTS = @"dapobjects";
NSString *const DS_DEFINITIONS = @"definitions";
NSString *const DS_DAPMETASCHEMA = @"dapmetaschema";
NSString *const DS_INDEX = @"index";
NSString *const DS_IS_ROLE = @"_isrole";
NSString *const DS_OBJECTS = @"objects";
NSString *const DS_OBJTYPE = @"objtype";
NSString *const DS_PROPERTIES = @"properties";
NSString *const DS_REF = @"$ref";
NSString *const DS_REV = @"rev";
NSString *const DS_STPACKET = @"stpacket";
NSString *const DS_STHEADER = @"stheader";
NSString *const DS_TITLE = @"title";
NSString *const DS_TYPE = @"type";
NSString *const DS_USER_ID = @"userId";
NSString *const DS_BUID = @"buid";
NSString *const DS_SCHEMA_ID = @"$id";

NSUInteger const DS_CREATE_OBJECT_ACTION = 1;
NSUInteger const DS_UPDATE_OBJECT_ACTION = 2;
NSUInteger const DS_REMOVE_OBJECT_ACTION = 3;

@implementation DSSchemaObject

+ (NSDictionary *)fromObject:(NSDictionary<NSString *, id> *)object dapSchema:(nullable NSDictionary *)dapSchema {
    NSMutableDictionary *mutableObject = [object ds_deepMutableCopy];
    NSDictionary *resultObject = [DSJsonSchemaUtils extractSchemaObject:mutableObject dapSchema:dapSchema];

    return resultObject;
}

+ (NSDictionary *)setMetaObject:(NSDictionary<NSString *, id> *)object key:(NSString *)key value:(id)value {
    NSParameterAssert(key);

    NSMutableDictionary *mutableObject = [object ds_deepMutableCopy];

    NSMutableDictionary *typeProperty = nil;
    if ([self isSysObject:mutableObject]) {
        typeProperty = mutableObject.allValues.firstObject;
    }
    else {
        typeProperty = mutableObject;
    }

    NSMutableDictionary *meta = typeProperty[@"meta"];
    if (!meta) {
        meta = [NSMutableDictionary dictionary];
        typeProperty[@"meta"] = meta;
    }

    meta[key] = value;

    return [mutableObject copy];
}

+ (BOOL)isSysObject:(nullable NSDictionary<NSString *, id> *)object {
    if (!object) {
        return NO;
    }

    NSArray<NSString *> *allKeys = object.allKeys;
    if (allKeys.count > 1) {
        return NO;
    }

    // first property should be the subschema
    NSString *subSchemaName = allKeys.firstObject;
    if (subSchemaName) {
        NSDictionary<NSString *, id> *properties = DSSchemaStorage.system[@"properties"];
        NSArray<NSString *> *keys = properties.allKeys;
        return [keys containsObject:subSchemaName];
    }

    return NO;
}

+ (nullable NSString *)hashOfObject:(NSDictionary<NSString *, id> *)object dapSchema:(nullable NSDictionary *)dapSchema {
    NSString *subSchemaName = object.allKeys.firstObject;
    if ([subSchemaName isEqualToString:@"subtx"]) {
        return [DSSchemaHash subtx:object];
    }
    else if ([subSchemaName isEqualToString:@"blockchainuser"]) {
        return [DSSchemaHash blockchainuser:object];
    }
    else if ([subSchemaName isEqualToString:@"stheader"]) {
        return [DSSchemaHash stheader:object];
    }
    else if ([subSchemaName isEqualToString:@"stpacket"]) {
        return [DSSchemaHash stpacket:object dapSchema:dapSchema];
    }
    else if ([subSchemaName isEqualToString:@"dapcontract"]) {
        return [DSSchemaHash dapcontract:object];
    }
    else if ([subSchemaName isEqualToString:@"dapschema"]) {
        return [DSSchemaHash dapschema:object];
    }
    else {
        return [DSSchemaHash dapobject:object dapSchema:dapSchema];
    }
}

+ (NSDictionary *)prepareForRemoval:(NSDictionary<NSString *, id> *)object {
    NSMutableDictionary *mutableObject = [object mutableCopy];
    mutableObject[DS_ACT] = @(DS_REMOVE_OBJECT_ACTION);
    NSUInteger rev = [object[DS_REV] unsignedIntegerValue] + 1;
    mutableObject[DS_REV] = @(rev);
    return [mutableObject copy];
}

+ (nullable NSString *)metaFromObject:(NSDictionary<NSString *, id> *)object byKey:(NSString *)key {
    NSParameterAssert(key);
    NSDictionary *meta = object[@"meta"];
    return meta[key];
}

@end

NS_ASSUME_NONNULL_END

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

#import "DSchemaDefinition.h"

static NSString *const kRelationDefinition = @"http://dash.org/schemas/sys#/definitions/relation";

NS_ASSUME_NONNULL_BEGIN

@implementation DSchemaDefinition

+ (nullable NSDictionary *)getDAPSubSchema:(NSDictionary *)object dapSchema:(NSDictionary *)dapSchema {
    id key = object[@"objtype"];
    return dapSchema[key];
}

+ (NSDictionary<NSString *, NSArray<NSString *> *> *)getSchemaRelations:(NSDictionary *)dapSchema {
    NSMutableDictionary<NSString *, NSArray<NSString *> *> *relations = [NSMutableDictionary dictionary];
    for (NSString *key in dapSchema) {
        NSAssert([key isKindOfClass:NSString.class], @"Unexpected type");
        NSArray<NSString *> *subSchemaRelations = [self getSubSchemaRelations:dapSchema subSchemaKey:key];
        if (subSchemaRelations.count > 0) {
            relations[key] = subSchemaRelations;
        }
    }
    return [relations copy];
}

+ (NSArray<NSString *> *)getSubSchemaRelations:(NSDictionary *)dapSchema subSchemaKey:(NSString *)subSchemaKey {
    NSDictionary *subSchema = dapSchema[subSchemaKey];
    NSDictionary *subSchemaProperties = subSchema[@"properties"];

    NSMutableArray<NSString *> *relations = [NSMutableArray array];
    for (NSString *key in subSchemaProperties) {
        NSAssert([key isKindOfClass:NSString.class], @"Unexpected type");
        NSDictionary *propertyDefinition = subSchemaProperties[key];
        if ([propertyDefinition[@"$ref"] isEqualToString:kRelationDefinition]) {
            [relations addObject:key];
        }
    }

    return [relations copy];
}

@end

NS_ASSUME_NONNULL_END

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

#import "DSSchemaCompile.h"

#import "DSJsonSchemaUtils.h"
#import "DSSchemaObject.h"
#import "DSSchemaStorage.h"
#import "DSValidationResult.h"

NS_ASSUME_NONNULL_BEGIN

static NSSet<NSString *> *ReservedKeywords() {
    return [NSSet setWithObjects:@"dash", nil];
}

static NSString *const DAP_SCHEMA_ID_URI = @"http://dash.org/schemas/dapschema";
static NSString *const DAP_OBJECT_BASE_REF = @"http://dash.org/schemas/sys#/definitions/dapobjectbase";

@implementation DSSchemaCompile

+ (DSValidationResult *)compileDAPSchema:(NSDictionary<NSString *, id> *)dapSchema {
    // valid id tag
    NSString *schemaId = dapSchema[DS_SCHEMA_ID];
    if (![schemaId isEqualToString:DAP_SCHEMA_ID_URI]) {
        return [[DSValidationResult alloc] initWithErrorCode:DSValidationResultErrorCodeInvalidID
                                                     objType:@"DAPSchema"
                                                    propName:DS_SCHEMA_ID
                                                  schemaName:nil];
    }

    // has title
    NSString *title = dapSchema[DS_TITLE];
    if (![title isKindOfClass:NSString.class] || !(title.length > 2 && title.length < 25)) {
        return [[DSValidationResult alloc] initWithErrorCode:DSValidationResultErrorCodeInvalidSchemaTitle
                                                     objType:@"DAPSchema"
                                                    propName:DS_TITLE
                                                  schemaName:nil];
    }

    // subschema count
    NSUInteger count = dapSchema.count;
    if (count < 3 || count > 1002) {
        return [[DSValidationResult alloc] initWithErrorCode:DSValidationResultErrorCodeInvalidDAPSubschemaCount
                                                     objType:@"DAPSchema"
                                                    propName:@"count"
                                                  schemaName:nil];
    }

    // validate the DAP Schema using JSON Schema
    DSValidationResult *result = [DSJsonSchemaUtils validateDapSchemaDef:dapSchema];
    if (!result.valid) {
        return result;
    }

    // check subschemas
    for (NSString *keyword in dapSchema) {
        NSDictionary<NSString *, id> *subSchema = dapSchema[keyword];
        DSValidationResult *result = [self compileDAPSubschema:subSchema keyword:keyword];
        if (!result.valid) {
            return result;
        }
    }

    return [[DSValidationResult alloc] initAsValid];
}

#pragma mark - Private

+ (DSValidationResult *)compileDAPSubschema:(NSDictionary<NSString *, id> *)dapSchema keyword:(NSString *)keyword {
    if ([keyword isEqualToString:DS_SCHEMA_ID] || [keyword isEqualToString:DS_SCHEMA] || [keyword isEqualToString:DS_TITLE]) {
        return [[DSValidationResult alloc] initAsValid];
    }

    if (!(keyword.length > 2 && keyword.length < 25)) {
        return [[DSValidationResult alloc] initWithErrorCode:DSValidationResultErrorCodeInvalidDAPSubschemaName
                                                     objType:@"invalid name length"
                                                    propName:nil
                                                  schemaName:keyword];
    }

    // invalid chars
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@"[^a-z0-9._]" options:kNilOptions error:NULL];
    NSParameterAssert(regexp);
    NSRange fullRange = NSMakeRange(0, keyword.length);
    BOOL invalid = [regexp numberOfMatchesInString:keyword options:kNilOptions range:fullRange] != 0;
    if (invalid) {
        return [[DSValidationResult alloc] initWithErrorCode:DSValidationResultErrorCodeInvalidDAPSubschemaName
                                                     objType:@"disallowed name characters"
                                                    propName:nil
                                                  schemaName:keyword];
    }

    // subschema reserved keyword from params
    NSSet<NSString *> *reservedKeywords = ReservedKeywords();
    if ([reservedKeywords containsObject:keyword]) {
        return [[DSValidationResult alloc] initWithErrorCode:DSValidationResultErrorCodeReservedDAPSubschemaName
                                                     objType:@"reserved param keyword"
                                                    propName:nil
                                                  schemaName:keyword];
    }

    // subschema reserved keyword from sys schema properties
    NSDictionary<NSString *, id> *systemSchema = DSSchemaStorage.system;
    NSDictionary<NSString *, id> *properties = systemSchema[DS_PROPERTIES];
    if ([properties.allKeys containsObject:keyword]) {
        return [[DSValidationResult alloc] initWithErrorCode:DSValidationResultErrorCodeReservedDAPSubschemaName
                                                     objType:@"reserved sysobject keyword"
                                                    propName:nil
                                                  schemaName:keyword];
    }

    // subschema reserved keyword from sys schema definitions
    NSDictionary<NSString *, id> *definitions = systemSchema[DS_DEFINITIONS];
    if ([definitions.allKeys containsObject:keyword]) {
        return [[DSValidationResult alloc] initWithErrorCode:DSValidationResultErrorCodeReservedDAPSubschemaName
                                                     objType:@"reserved sysschema keyword"
                                                    propName:nil
                                                  schemaName:keyword];
    }

    // schema inheritance
    NSDictionary<NSString *, id> *subSchema = dapSchema[keyword];
    NSArray<NSDictionary *> *allOf = subSchema[DS_ALL_OF];
    if (!allOf) {
        return [[DSValidationResult alloc] initWithErrorCode:DSValidationResultErrorCodeDAPSubschemaInheritance
                                                     objType:@"dap subschema inheritance missing"
                                                    propName:nil
                                                  schemaName:keyword];
    }

    if (![allOf isKindOfClass:NSArray.class]) {
        return [[DSValidationResult alloc] initWithErrorCode:DSValidationResultErrorCodeDAPSubschemaInheritance
                                                     objType:@"dap subschema inheritance invalid"
                                                    propName:nil
                                                  schemaName:keyword];
    }

    NSDictionary<NSString *, NSString *> *allOfRule = allOf.firstObject;
    NSString *ref = allOfRule.allValues.firstObject;
    if (![ref isEqualToString:DAP_OBJECT_BASE_REF]) {
        return [[DSValidationResult alloc] initWithErrorCode:DSValidationResultErrorCodeDAPSubschemaInheritance
                                                     objType:@"dap subschema inheritance invalid"
                                                    propName:nil
                                                  schemaName:keyword];
    }

    return [DSJsonSchemaUtils validateDapSubschemaDef:subSchema];
}

@end

NS_ASSUME_NONNULL_END

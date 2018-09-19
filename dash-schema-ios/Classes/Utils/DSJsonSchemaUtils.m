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

#import "DSJsonSchemaUtils.h"

#import "DSJSONSchema+DashSchema.h"
#import "DSValidationResult.h"
#import "DSSchemaStorage.h"

NS_ASSUME_NONNULL_BEGIN

@implementation DSJsonSchemaUtils

+ (DSValidationResult *)validateSchemaObject:(NSDictionary *)object dapSchema:(nullable NSDictionary *)dapSchema {
    DSJSONSchema *schema = nil;
    if (dapSchema) {
        schema = [DSJSONSchema dashCustomSchemaWithObject:dapSchema removeAdditional:NO error:NULL];
    }
    else {
        schema = [DSJSONSchema systemSchemaRemoveAdditional:NO];
    }
    
    NSError *error = nil;
    BOOL valid = [schema validateObject:object withError:&error];
    if (valid) {
        return [[DSValidationResult alloc] initAsValid];
    }
    
    NSString *objType = nil;
    if (dapSchema) {
        objType = object[@"objtype"] ?: @"";
    }
    else {
        objType = object.allKeys.firstObject;
    }
    
    return [[DSValidationResult alloc] initWithError:error objType:objType propName:nil schemaName:schema.title];
}

+ (DSValidationResult *)validateDapSchemaDef:(NSDictionary *)dapSchema {
    NSError *error = nil;
    __unused DSJSONSchema *schema = [DSJSONSchema dashCustomSchemaWithObject:dapSchema removeAdditional:NO error:&error];
    if (error) {
        return [[DSValidationResult alloc] initWithError:error objType:nil propName:nil schemaName:nil];
    }
    
    return [[DSValidationResult alloc] initAsValid];
}

+ (DSValidationResult *)validateDapSubschemaDef:(NSDictionary *)dapSubschema {
    NSDictionary *systemSchemaObject = [DSSchemaStorage system];
    NSDictionary *dapMetaSchemaObject = systemSchemaObject[@"definitions"][@"dapmetaschema"];
    NSParameterAssert(dapMetaSchemaObject);
    DSJSONSchema *dapMetaSchema = [DSJSONSchema dashCustomSchemaWithObject:dapMetaSchemaObject removeAdditional:NO error:NULL];
    
    NSError *error = nil;
    BOOL valid = [dapMetaSchema validateObject:dapSubschema withError:&error];
    if (!valid) {
        return [[DSValidationResult alloc] initWithError:error objType:nil propName:nil schemaName:nil];
    }
    
    DSJSONSchema *systemSchema = [DSJSONSchema systemSchemaRemoveAdditional:NO];
    valid = [systemSchema validateObject:dapSubschema withError:&error];
    if (!valid) {
        return [[DSValidationResult alloc] initWithError:error objType:nil propName:nil schemaName:nil];
    }
    
    return [[DSValidationResult alloc] initAsValid];
}

+ (DSValidationResult *)validateSchemaDef:(NSDictionary *)schemaObject {
    DSJSONSchema *systemSchema = [DSJSONSchema systemSchemaRemoveAdditional:NO];
    NSError *error = nil;
    BOOL valid = [systemSchema validateObject:schemaObject withError:&error];
    if (!valid) {
        return [[DSValidationResult alloc] initWithError:error objType:nil propName:nil schemaName:nil];
    }
    
    return [[DSValidationResult alloc] initAsValid];
}

+ (NSDictionary *)extractSchemaObject:(NSMutableDictionary *)mutableObject dapSchema:(nullable NSDictionary *)dapSchema {
    DSJSONSchema *schema = nil;
    if (dapSchema) {
        schema = [DSJSONSchema dashCustomSchemaWithObject:dapSchema removeAdditional:YES error:NULL];
    }
    else {
        schema = [DSJSONSchema systemSchemaRemoveAdditional:YES];
    }
    
    NSError *error = nil;
    [schema validateObject:mutableObject withError:&error];
    
    if (error) {
        // TODO: Check expected type of added errors
        mutableObject[@"errors"] = error;
    }
    
    return [mutableObject copy];
}

@end

NS_ASSUME_NONNULL_END

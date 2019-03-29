//
//  Created by Andrew Podkovyrin
//  Copyright © 2019 Dash Core Group. All rights reserved.
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

#import "DPJSONSchemaValidator.h"

#import <DSJSONSchemaValidation/DSJSONSchema.h>
#import <DSJSONSchemaValidation/DSJSONSchemaStorage.h>

#import "NSBundle+DSSchema.h"

NS_ASSUME_NONNULL_BEGIN

@interface DPJSONSchemaValidator ()

@property (strong, nonatomic) DSJSONSchemaStorage *schemaStorage;
@property (strong, nonatomic) NSMutableDictionary<NSNumber *, DSJSONSchema *> *schemas;

@end

@implementation DPJSONSchemaValidator

- (nullable instancetype)init {
    self = [super init];
    if (self) {
        DSMutableJSONSchemaStorage *schemaStorage = [DSMutableJSONSchemaStorage storage];

        DSJSONSchema *jsonSchema = [self.class schemaForFilename:@"schema_v7"
                                                referenceStorage:nil];
        NSAssert(jsonSchema, @"JSON Schema should exists");
        if (!jsonSchema) {
            return nil;
        }
        [schemaStorage addSchema:jsonSchema];

        DSJSONSchema *dashSchema = [self.class schemaForFilename:@"dash-schema"
                                                referenceStorage:schemaStorage];
        NSAssert(dashSchema, @"Dash schema should exists");
        if (!dashSchema) {
            return nil;
        }
        [schemaStorage addSchema:dashSchema];

        DSJSONSchema *stPacketHeaderSchema = [self.class schemaForFilename:@"st-packet-header"
                                                          referenceStorage:schemaStorage];
        if (!stPacketHeaderSchema) {
            return nil;
        }
        NSAssert(stPacketHeaderSchema, @"STPacket Header schema should exists");
        [schemaStorage addSchema:stPacketHeaderSchema];

        DSJSONSchema *dpContractSchema = [self.class schemaForFilename:@"dp-contract"
                                                      referenceStorage:schemaStorage];
        NSAssert(dpContractSchema, @"DPContract schema should exists");
        if (!dpContractSchema) {
            return nil;
        }
        [schemaStorage addSchema:dpContractSchema];

        NSMutableDictionary<NSNumber *, DSJSONSchema *> *schemas = [NSMutableDictionary dictionary];
        schemas[@(DPJSONSchemaValidatorType_DPContract)] = dpContractSchema;
        schemas[@(DPJSONSchemaValidatorType_STPacketHeader)] = stPacketHeaderSchema;

        _schemaStorage = [schemaStorage copy];
        _schemas = schemas;
    }
    return self;
}

- (nullable NSError *)validateObject:(DPJSONObject *)jsonObject forType:(DPJSONSchemaValidatorType)type {
    DSJSONSchema *schema = [self schemaForType:type];
    NSError *error = nil;
    [schema validateObject:jsonObject withError:&error];

    return error;
}

#pragma mark - Private

- (DSJSONSchema *)schemaForType:(DPJSONSchemaValidatorType)type {
    NSNumber *key = @(type);
    DSJSONSchema *schema = self.schemas[key];
    if (!schema) {
        switch (type) {
            case DPJSONSchemaValidatorType_DPObject: {
                schema = [self.class schemaForFilename:@"dp-object"
                                      referenceStorage:self.schemaStorage];
                NSAssert(schema, @"DPObject schema should exists");
                self.schemas[key] = schema;

                break;
            }
            case DPJSONSchemaValidatorType_STPacket: {
                schema = [self.class schemaForFilename:@"st-packet"
                                      referenceStorage:self.schemaStorage];
                NSAssert(schema, @"STPacket schema should exists");
                self.schemas[key] = schema;

                break;
            }
            default:
                NSAssert(NO, @"The schema for type %ld should have been instantiated during -init", type);

                break;
        }
    }

    return schema;
}

#pragma mark - Private Factory

+ (NSDictionary<NSString *, id> *)schemaJSONObjectForFilename:(NSString *)filename {
    NSURL *url = [[NSBundle ds_dashSchemaBundle] URLForResource:filename
                                                  withExtension:@"json"];
    NSAssert(url, @"The resource `%@` not found in application bundle", filename);

    NSData *data = [NSData dataWithContentsOfURL:url];
    NSAssert(data, @"Invalid data object at `%@`", url);

    NSError *error = nil;
    NSDictionary<NSString *, id> *json = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:(NSJSONReadingOptions)kNilOptions
                                                                           error:&error];
    NSAssert(error == nil, @"Failed to parse JSON from data %@", error);

    return json;
}

+ (DSJSONSchema *)schemaForSchemaObject:(NSDictionary<NSString *, id> *)schemaObject
                       referenceStorage:(nullable DSJSONSchemaStorage *)referenceStorage {
    NSError *error = nil;
    DSJSONSchema *schema = [DSJSONSchema schemaWithObject:schemaObject
                                                  baseURI:nil
                                         referenceStorage:referenceStorage
                                            specification:[DSJSONSchemaSpecification draft7]
                                                  options:nil
                                                    error:&error];
    NSAssert(error == nil, @"Failed to instantiate JSON schema: %@", schemaObject);
    NSAssert(schema, @"Failed to instantiate JSON schema: %@", schemaObject);

    return schema;
}

+ (DSJSONSchema *)schemaForFilename:(NSString *)filename
                   referenceStorage:(nullable DSJSONSchemaStorage *)referenceStorage {
    NSDictionary<NSString *, id> *schemaObject = [self schemaJSONObjectForFilename:filename];
    DSJSONSchema *schema = [self schemaForSchemaObject:schemaObject
                                      referenceStorage:referenceStorage];

    return schema;
}

@end

NS_ASSUME_NONNULL_END

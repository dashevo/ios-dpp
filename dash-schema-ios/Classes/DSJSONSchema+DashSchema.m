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

#import "DSJSONSchema+DashSchema.h"

#import "DSSchemaStorage.h"
#import "DSJSONSchemaPVerValidator.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Storage

@interface DSDashSchemaStorage: NSObject

@property (strong, nonatomic) VVMutableJSONSchemaStorage *storage;

@end

@implementation DSDashSchemaStorage

+ (instancetype)sharedInstance {
    static DSDashSchemaStorage *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _storage = [VVMutableJSONSchemaStorage storage];
        
        [self addSchema:[DSJSONSchema jsonSchemaRemoveAdditional:NO]
           withScopeURI:[NSURL URLWithString:@"http://json-schema.org/draft-07/schema#"]];
    }
    return self;
}

- (void)addSchema:(DSJSONSchema *)schema withScopeURI:(NSURL *)scopeURI {
    BOOL success = [self.storage addSchema:schema];
    if (success == NO) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"Failed to add reference schema with scope URI %@ into the storage.", scopeURI];
    }
}

@end

#pragma mark - Schema

@implementation DSJSONSchema (DashSchema)

+ (void)load {
    BOOL success = [DSJSONSchema registerValidatorClass:DSJSONSchemaPVerValidator.class
                                       forMetaschemaURI:nil
                                          specification:[DSJSONSchemaSpecification draft7]
                                              withError:NULL];
    
    if (success == NO) {
        [NSException raise:NSInternalInconsistencyException format:@"Failed to register Dash Schema validator."];
    }
}

+ (instancetype)systemSchemaRemoveAdditional:(BOOL)removeAdditional {
    return [self dashCustomSchemaWithObject:[DSSchemaStorage system] removeAdditional:removeAdditional error:NULL];
}

+ (instancetype)jsonSchemaRemoveAdditional:(BOOL)removeAdditional {
    return [self customSchemaWithObject:[DSSchemaStorage json]
                       referenceStorage:nil
                       removeAdditional:removeAdditional
                                  error:NULL];
}

+ (instancetype)dashCustomSchemaWithObject:(NSDictionary *)schemaObject
                          removeAdditional:(BOOL)removeAdditional
                                     error:(NSError * __autoreleasing *)error {
    VVMutableJSONSchemaStorage *storage = [DSDashSchemaStorage sharedInstance].storage;
    DSJSONSchema *schema = [self customSchemaWithObject:schemaObject
                                       referenceStorage:storage
                                       removeAdditional:removeAdditional
                                                  error:error];
    return schema;
}

+ (instancetype)customSchemaWithObject:(NSDictionary *)schemaObject
                      referenceStorage:(nullable DSJSONSchemaStorage *)referenceStorage
                      removeAdditional:(BOOL)removeAdditional
                                 error:(NSError * __autoreleasing *)error {
    DSJSONSchemaValidationOptions *options = [[DSJSONSchemaValidationOptions alloc] init];
    if (removeAdditional) {
        options.removeAdditional = DSJSONSchemaValidationOptionsRemoveAdditionalYes;
    }
    
    DSJSONSchema *schema = [DSJSONSchema schemaWithObject:schemaObject
                                                  baseURI:nil
                                         referenceStorage:referenceStorage
                                            specification:[DSJSONSchemaSpecification draft7]
                                                  options:options
                                                    error:error];
    return schema;
}

@end

NS_ASSUME_NONNULL_END
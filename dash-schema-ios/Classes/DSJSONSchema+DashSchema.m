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

NS_ASSUME_NONNULL_BEGIN

@implementation DSJSONSchema (DashSchema)

+ (instancetype)systemSchema {
    return [self systemSchemaRemoveAdditional:NO];
}

+ (instancetype)jsonSchema {
    return [self jsonSchemaRemoveAdditional:NO];
}

+ (instancetype)systemSchemaRemoveAdditional:(BOOL)removeAdditional {
    DSJSONSchemaValidationOptions *options = [[DSJSONSchemaValidationOptions alloc] init];
    if (removeAdditional) {
        options.removeAdditional = DSJSONSchemaValidationOptionsRemoveAdditionalYes;
    }
    
    NSError *error = nil;
    DSJSONSchema *schema = [DSJSONSchema schemaWithObject:[DSSchemaStorage system]
                                                  baseURI:nil
                                         referenceStorage:nil
                                            specification:[DSJSONSchemaSpecification draft7]
                                                  options:options
                                                    error:&error];
    NSParameterAssert(!error);
    return schema;
}

+ (instancetype)jsonSchemaRemoveAdditional:(BOOL)removeAdditional {
    DSJSONSchemaValidationOptions *options = [[DSJSONSchemaValidationOptions alloc] init];
    if (removeAdditional) {
        options.removeAdditional = DSJSONSchemaValidationOptionsRemoveAdditionalYes;
    }
    
    NSError *error = nil;
    DSJSONSchema *schema = [DSJSONSchema schemaWithObject:[DSSchemaStorage json]
                                                  baseURI:nil
                                         referenceStorage:nil
                                            specification:[DSJSONSchemaSpecification draft7]
                                                  options:options
                                                    error:&error];
    NSParameterAssert(!error);
    return schema;
}

@end

NS_ASSUME_NONNULL_END

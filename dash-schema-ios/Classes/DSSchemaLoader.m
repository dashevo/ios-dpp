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

#import "DSSchemaLoader.h"

#import <DSJSONSchemaValidation/DSJSONSchema.h>
#import "NSBundle+DSDashSchema.h"

NS_ASSUME_NONNULL_BEGIN

@implementation DSSchemaLoader

@synthesize systemSchema = _systemSchema;
@synthesize jsonSchema = _jsonSchema;

- (DSJSONSchema *)systemSchema {
    if (!_systemSchema) {
        NSURL *url = [[NSBundle ds_dashSchemaBundle] URLForResource:@"dash_system_schema" withExtension:@"json"];
        NSParameterAssert(url);
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSParameterAssert(data);
        NSError *error = nil;
        _systemSchema = [DSJSONSchema schemaWithData:data
                                           baseURI:nil
                                  referenceStorage:nil
                                     specification:[DSJSONSchemaSpecification draft7]
                                           options:nil
                                             error:&error];
#ifdef DEBUG
        if (error) {
            NSLog(@"Initialization dash system schema: %@", error);
        }
#endif
    }
    return _systemSchema;
}

- (DSJSONSchema *)jsonSchema {
    if (!_jsonSchema) {
        NSURL *url = [[NSBundle ds_dashSchemaBundle] URLForResource:@"schema_v7" withExtension:@"json"];
        NSParameterAssert(url);
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSParameterAssert(data);
        NSError *error = nil;
        _jsonSchema = [DSJSONSchema schemaWithData:data
                                           baseURI:nil
                                  referenceStorage:nil
                                     specification:[DSJSONSchemaSpecification draft7]
                                           options:nil
                                             error:&error];
#ifdef DEBUG
        if (error) {
            NSLog(@"Initialization json schema: %@", error);
        }
#endif
    }
    return _jsonSchema;
}

@end

NS_ASSUME_NONNULL_END

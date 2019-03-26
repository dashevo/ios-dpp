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

#import "DPContractFactory.h"

NS_ASSUME_NONNULL_BEGIN

@implementation DPContractFactory

- (DPContract *)contractWithName:(NSString *)name
                      documents:(NSDictionary<NSString *, DPJSONObject *> *)documents {
    DPContract *contract = [self.class contractFromRawContract:@{
        @"name" : name,
        @"documents" : documents,
    }];
    
    return contract;
}

- (nullable DPContract *)contractFromRawContract:(DPJSONObject *)rawContract
                                           error:(NSError *_Nullable __autoreleasing *)error {
    return [self contractFromRawContract:rawContract skipValidation:NO error:error];
}

- (nullable DPContract *)contractFromRawContract:(DPJSONObject *)rawContract
                                  skipValidation:(BOOL)skipValidation
                                           error:(NSError *_Nullable __autoreleasing *)error {
    // TODO: validate rawContract
    
    DPContract *contract = [self.class contractFromRawContract:rawContract];
    
    return contract;
}

// TODO add method to create from cbor

#pragma mark - Private

+ (DPContract *)contractFromRawContract:(DPJSONObject *)rawContract {
    NSString *name = rawContract[@"name"];
    NSDictionary<NSString *, DPJSONObject *> *documents = rawContract[@"documents"];

    DPContract *contract = [[DPContract alloc] initWithName:name
                                        documents:documents];

    NSString *jsonMetaSchema = rawContract[@"$schema"];
    if (jsonMetaSchema) {
        contract.jsonMetaSchema = jsonMetaSchema;
    }

    NSNumber *version = rawContract[@"version"];
    if (version) {
        contract.version = version.integerValue;
    }

    NSDictionary<NSString *, DPJSONObject *> *definitions = rawContract[@"definitions"];
    if (definitions) {
        contract.definitions = definitions;
    }

    return contract;
}

@end

NS_ASSUME_NONNULL_END

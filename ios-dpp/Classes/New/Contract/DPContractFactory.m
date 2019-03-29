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

#import "DPContractFactory+CreateContract.h"

NS_ASSUME_NONNULL_BEGIN

@implementation DPContractFactory

- (DPContract *)contractWithName:(NSString *)name
                       documents:(NSDictionary<NSString *, DPJSONObject *> *)documents {
    DPContract *contract = [self.class dp_contractFromRawContract:@{
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

    DPContract *contract = [self.class dp_contractFromRawContract:rawContract];

    return contract;
}

// TODO create contract from cbor

@end

NS_ASSUME_NONNULL_END

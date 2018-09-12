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

NS_ASSUME_NONNULL_BEGIN

@implementation DSJsonSchemaUtils

+ (NSDictionary *)extractSchemaObject:(NSMutableDictionary *)mutableObject dapSchema:(nullable NSDictionary *)dapSchema {
    DSJSONSchema *schema = nil;
    if (dapSchema) {
        schema = [DSJSONSchema dashCustomSchemaWithObject:dapSchema removeAdditional:YES];
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

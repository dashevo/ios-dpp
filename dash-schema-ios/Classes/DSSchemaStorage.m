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

#import "DSSchemaStorage.h"

#import "NSBundle+DSDashSchema.h"

NS_ASSUME_NONNULL_BEGIN

@implementation DSSchemaStorage

+ (NSDictionary *)system {
    static NSDictionary *object = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [[NSBundle ds_dashSchemaBundle] URLForResource:@"dash_system_schema" withExtension:@"json"];
        NSParameterAssert(url);
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSParameterAssert(data);
        NSError *error = nil;
        object = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)kNilOptions error:&error];
        NSParameterAssert(!error);
    });
    return object;
}

+ (NSDictionary *)json {
    static NSDictionary *object = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [[NSBundle ds_dashSchemaBundle] URLForResource:@"schema_v7" withExtension:@"json"];
        NSParameterAssert(url);
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSParameterAssert(data);
        NSError *error = nil;
        object = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)kNilOptions error:&error];
        NSParameterAssert(!error);
    });
    return object;
}

@end

NS_ASSUME_NONNULL_END

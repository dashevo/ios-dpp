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

#import "DSSchemaObject.h"

#import <DSJSONSchemaValidation/NSDictionary+DSJSONDeepMutableCopy.h>
#import "DSJsonSchemaUtils.h"

NS_ASSUME_NONNULL_BEGIN

NSString * const DS_ACT = @"act";
NSString * const DS_ALL_OF = @"allOf";
NSString * const DS_DAPOBJECTS = @"dapobjects";
NSString * const DS_DEFINITIONS = @"definitions";
NSString * const DS_DAPMETASCHEMA = @"dapmetaschema";
NSString * const DS_INDEX = @"index";
NSString * const DS_IS_ROLE = @"_isrole";
NSString * const DS_OBJECTS = @"objects";
NSString * const DS_OBJTYPE = @"objtype";
NSString * const DS_PROPERTIES = @"properties";
NSString * const DS_REF = @"$ref";
NSString * const DS_REV = @"rev";
NSString * const DS_STPACKET = @"stpacket";
NSString * const DS_STHEADER = @"stheader";
NSString * const DS_TITLE = @"title";
NSString * const DS_TYPE = @"type";
NSString * const DS_USER_ID = @"userId";
NSString * const DS_BUID = @"buid";
NSString * const DS_SCHEMA_ID = @"$id";

@implementation DSSchemaObject

+ (NSDictionary *)fromObject:(NSDictionary *)object dapSchema:(nullable NSDictionary *)dapSchema {
    NSMutableDictionary *mutableObject = [object ds_deepMutableCopy];
    NSDictionary *resultObject = [DSJsonSchemaUtils extractSchemaObject:mutableObject dapSchema:dapSchema];
    
    return resultObject;
}

@end

NS_ASSUME_NONNULL_END

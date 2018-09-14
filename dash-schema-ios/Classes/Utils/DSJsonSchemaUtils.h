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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DSValidationResult;

@interface DSJsonSchemaUtils : NSObject

/**
 * Validate a System Object or DAP Object.
 * DAP Object validation requires input of the DAP Schema.
 */
+ (DSValidationResult *)validateSchemaObject:(NSDictionary *)object dapSchema:(nullable NSDictionary *)dapSchema;
+ (DSValidationResult *)validateDapSchemaDef:(NSDictionary *)dapSchema;
+ (DSValidationResult *)validateDapSubschemaDef:(NSDictionary *)dapSubschema;
+ (DSValidationResult *)validateSchemaDef:(NSDictionary *)schemaObject;

+ (NSDictionary *)extractSchemaObject:(NSMutableDictionary *)mutableObject dapSchema:(nullable NSDictionary *)dapSchema;

@end

NS_ASSUME_NONNULL_END
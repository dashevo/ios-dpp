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

@interface DSSchemaValidator : NSObject

/**
 * Validate a Subscription Transaction
 * @param object Schema object instance
 * @return Validation result
 */
+ (DSValidationResult *)validateSubTx:(NSDictionary *)object;

/**
 * Validate a Blockchain User
 * @param object Schema object instance
 * @return Validation result
 */
+ (DSValidationResult *)validateBlockchainUser:(NSDictionary *)object;

/**
 * Validate a State Transition Header
 * @param object Schema object instance
 * @return Validation result
 */
+ (DSValidationResult *)validateSTHeader:(NSDictionary *)object;

/**
 * Validate a State Transition Packet. When the packets contain dapobjects,
 * the DapSchema parameter is required
 * @param object Schema object instance
 * @param dapSchema DapSchema (optional)
 * @return Validation result
 */
+ (DSValidationResult *)validateSTPacketObject:(NSDictionary *)object dapSchema:(nullable NSDictionary *)dapSchema;

/**
 * Validate the objects from a Transition packet
 * against a DapSchema and additional packet consensus rules
 * @param dapObjects DAP Objects
 * @param dapSchema DapSchema
 * @return Validation result
 */
+ (DSValidationResult *)validateSTPacketObjects:(NSArray *)dapObjects dapSchema:(NSDictionary *)dapSchema;

/**
 * Validate a DapContract instance
 * @param object Schema object instance
 * @return Validation result
 */
+ (DSValidationResult *)validateDapContract:(NSDictionary *)object;

/**
 * Validate a DapObject instance
 * @param dapObject Schema object instance
 * @param dapSchema DapSchema
 * @return Validation result
 */
+ (DSValidationResult *)validateDapObject:(NSDictionary *)dapObject dapSchema:(NSDictionary *)dapSchema;

/**
 * Validate a username using DIP 011 rules
 * @param username Blockchain Username
 */
+ (BOOL)validateBlockchainUsername:(NSString *)username;

@end

NS_ASSUME_NONNULL_END

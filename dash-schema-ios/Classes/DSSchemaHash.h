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

@interface DSSchemaHash : NSObject

+ (nullable NSString *)subtx:(NSDictionary *)object;
+ (nullable NSString *)blockchainuser:(NSDictionary *)object;
+ (nullable NSString *)stheader:(NSDictionary *)object;
+ (nullable NSString *)stpacket:(NSDictionary *)object dapSchema:(nullable NSDictionary *)dapSchema;
+ (nullable NSString *)dapcontract:(NSDictionary *)object;
+ (nullable NSString *)dapschema:(NSDictionary *)object;
+ (nullable NSString *)dapobject:(NSDictionary *)object dapSchema:(nullable NSDictionary *)dapSchema;

@end

NS_ASSUME_NONNULL_END

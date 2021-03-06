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

#import "NSBundle+DPP.h"

#import "DashPlatformProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSBundle (DSSchema)

+ (instancetype)dp_dppBundle {
    NSString *bundlePath = [[NSBundle bundleForClass:DashPlatformProtocol.class] pathForResource:@"ios-dpp" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSParameterAssert(bundle);
    return bundle;
}

@end

NS_ASSUME_NONNULL_END

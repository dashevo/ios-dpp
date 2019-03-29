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

#import "DPSTPacketFacade.h"

#import "DPSTPacketFactory.h"

NS_ASSUME_NONNULL_BEGIN

@interface DPSTPacketFacade ()

@property (strong, nonatomic) DPSTPacketFactory *factory;

@end

@implementation DPSTPacketFacade

- (instancetype)initWithMerkleRootOperation:(id<DPMerkleRootOperation>)merkleRootOperation {
    self = [super init];
    if (self) {
        _factory = [[DPSTPacketFactory alloc] initWithMerkleRootOperation:merkleRootOperation];
    }
    return self;
}

- (DPSTPacket *)packetWithContract:(DPContract *)contract {
    return [self.factory packetWithContract:contract];
}

- (DPSTPacket *)packetWithContractId:(NSString *)contractId
                           documents:(NSArray<DPDocument *> *)documents {
    return [self.factory packetWithContractId:contractId documents:documents];
}

- (nullable DPSTPacket *)packetWithRawPacket:(DPJSONObject *)rawPacket
                                       error:(NSError *_Nullable __autoreleasing *)error {
    return [self.factory packetWithRawPacket:rawPacket error:error];
}

- (nullable DPSTPacket *)packetWithRawPacket:(DPJSONObject *)rawPacket
                              skipValidation:(BOOL)skipValidation
                                       error:(NSError *_Nullable __autoreleasing *)error {
    return [self.factory packetWithRawPacket:rawPacket skipValidation:skipValidation error:error];
}

@end

NS_ASSUME_NONNULL_END

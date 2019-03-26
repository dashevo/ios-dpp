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

#import "DPSTPacketHeader.h"

#import "DSSchemaHashUtils.h"

NS_ASSUME_NONNULL_BEGIN

@implementation DPSTPacketHeader

#pragma mark - DPPSerializableObject

@synthesize json=_json;
@synthesize serialized=_serialized;
@synthesize serializedHash=_serializedHash;

- (DPMutableJSONObject *)json {
    if (_json == nil) {
        DPMutableJSONObject *json = [[DPMutableJSONObject alloc] init];
        json[@"contractId"] = self.dpContractId;
        json[@"itemsMerkleRoot"] = self.itemsMerkleRoot;
        json[@"itemsHash"] = self.itemsHash;
        _json = json;
    }
    return _json;
}

- (NSData *)serialized {
    if (_serialized == nil) {
        _serialized = [DSSchemaHashUtils serializeObject:self.json];
    }
    return _serialized;
}

- (NSData *)serializedHash {
    if (_serializedHash == nil) {
        _serializedHash = [DSSchemaHashUtils hashOfSerializedObject:self.serialized];
    }
    return _serializedHash;
}

#pragma mark - Private

- (void)setDpContractId:(NSString *)dpContractId {
    _dpContractId = [dpContractId copy];
    [self resetSerializedValues];
}

- (void)setItemsMerkleRoot:(NSString *)itemsMerkleRoot {
    _itemsMerkleRoot = [itemsMerkleRoot copy];
    [self resetSerializedValues];
}

- (void)setItemsHash:(NSString *)itemsHash {
    _itemsHash = [itemsHash copy];
    [self resetSerializedValues];
}

- (void)resetSerializedValues {
    _json = nil;
    _serialized = nil;
    _serializedHash = nil;
}

@end

NS_ASSUME_NONNULL_END

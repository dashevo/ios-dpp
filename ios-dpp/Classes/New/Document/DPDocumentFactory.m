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

#import "DPDocumentFactory.h"

#import "DPErrors.h"
#import "DSSchemaHashUtils.h"

NS_ASSUME_NONNULL_BEGIN

static NSInteger const DEFAULT_REVISION = 0;
static DPDocumentAction const DEFAULT_ACTION = DPDocumentAction_Create;

@interface DPDocumentFactory ()

@property (copy, nonatomic) NSString *userId;
@property (strong, nonatomic) DPContract *contract;
@property (strong, nonatomic) id<DPEntropyProvider> entropyProvider;

@end

@implementation DPDocumentFactory

- (instancetype)initWithUserId:(NSString *)userId
                         contract:(DPContract *)contract
                  entropyProvider:(id<DPEntropyProvider>)entropyProvider {
    self = [super init];
    if (self) {
        _userId = [userId copy];
        _contract = contract;
        _entropyProvider = entropyProvider;
    }
    return self;
}

- (nullable DPDocument *)documentWithType:(NSString *)type
                                 data:(nullable DPJSONObject *)data
                                error:(NSError *_Nullable __autoreleasing *)error {
    NSParameterAssert(type);

    if (!data) {
        data = @{};
    }

    if (![self.contract isDocumentDefinedForType:type]) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:DPErrorDomain
                                         code:DPErrorCode_InvalidDocumentType
                                     userInfo:@{ NSLocalizedDescriptionKey :
                                                     [NSString stringWithFormat:@"Contract '%@' doesn't contain type '%@'",
                                                                                self.contract.name, type],
                                     }];
        }
        
        return nil;
    }

    NSString *scopeString = [self.contract.identifier stringByAppendingString:self.userId];
    NSString *scopeStringHash = [DSSchemaHashUtils hashStringOfObject:scopeString];

    DPMutableJSONObject *rawObject = [[DPMutableJSONObject alloc] init];
    rawObject[@"$type"] = type;
    rawObject[@"$scope"] = scopeStringHash;
    rawObject[@"$scopeId"] = [self.entropyProvider generateEntropyString];
    rawObject[@"$action"] = @(DEFAULT_ACTION);
    rawObject[@"$rev"] = @(DEFAULT_REVISION);
    [rawObject addEntriesFromDictionary:data];
    
    DPDocument *object = [[DPDocument alloc] initWithRawDocument:rawObject];
    
    return object;
}

- (nullable DPDocument *)documentFromRawDocument:(DPJSONObject *)rawDocument
                                     error:(NSError *_Nullable __autoreleasing *)error {
    return [self documentFromRawDocument:rawDocument skipValidation:NO error:error];
}

- (nullable DPDocument *)documentFromRawDocument:(DPJSONObject *)rawDocument
                            skipValidation:(BOOL)skipValidation
                                     error:(NSError *_Nullable __autoreleasing *)error {
    // TODO: validate rawDocument

    DPDocument *object = [[DPDocument alloc] initWithRawDocument:rawDocument];

    return object;
}

// TODO: create document from cbor

@end

NS_ASSUME_NONNULL_END

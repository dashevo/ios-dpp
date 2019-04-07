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

#import "DPDocumentFacade.h"

#import "DPDocumentFactory.h"

NS_ASSUME_NONNULL_BEGIN

@interface DPDocumentFacade ()

@property (nullable, weak, nonatomic) DashPlatformProtocol *dpp;
@property (strong, nonatomic) id<DPEntropyProvider> entropyProvider;

@end

@implementation DPDocumentFacade

- (instancetype)initWithDPP:(DashPlatformProtocol *)dpp
            entropyProvider:(id<DPEntropyProvider>)entropyProvider {
    self = [super init];
    if (self) {
        _dpp = dpp;
        _entropyProvider = entropyProvider;
    }
    return self;
}

- (nullable DPDocument *)documentWithType:(NSString *)type
                                     data:(nullable DPJSONObject *)data
                                    error:(NSError *_Nullable __autoreleasing *)error {
    DPDocumentFactory *factory = [self factory];
    NSParameterAssert(factory);
    if (!factory) {
        return nil;
    }
    
    return [factory documentWithType:type data:data error:error];
}

- (nullable DPDocument *)documentFromRawDocument:(DPJSONObject *)rawDocument
                                         error:(NSError *_Nullable __autoreleasing *)error {
    DPDocumentFactory *factory = [self factory];
    NSParameterAssert(factory);
    if (!factory) {
        return nil;
    }

    return [factory documentFromRawDocument:rawDocument error:error];
}

- (nullable DPDocument *)documentFromRawDocument:(DPJSONObject *)rawDocument
                                skipValidation:(BOOL)skipValidation
                                         error:(NSError *_Nullable __autoreleasing *)error {
    DPDocumentFactory *factory = [self factory];
    NSParameterAssert(factory);
    if (!factory) {
        return nil;
    }

    return [factory documentFromRawDocument:rawDocument skipValidation:skipValidation error:error];
}

#pragma mark - Private

- (nullable DPDocumentFactory *)factory {
    NSString *userId = self.dpp.userId;
    NSParameterAssert(userId);
    if (!userId) {
        return nil;
    }
    DPContract *contract = self.dpp.contract;
    NSParameterAssert(contract);
    if (!contract) {
        return nil;
    }
    
    DPDocumentFactory *factory = [[DPDocumentFactory alloc] initWithUserId:userId
                                                                  contract:contract
                                                           entropyProvider:self.entropyProvider];
    
    return factory;
}


@end

NS_ASSUME_NONNULL_END

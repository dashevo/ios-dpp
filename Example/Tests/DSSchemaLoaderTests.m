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

#import <XCTest/XCTest.h>

#import <dash_schema_ios/DSJSONSchema+DashSchema.h>

@interface DSSchemaLoaderTests : XCTestCase

@end

@implementation DSSchemaLoaderTests

- (void)testLoadingSchemas {
    DSJSONSchema *jsonSchema = [DSJSONSchema jsonSchemaRemoveAdditional:NO];
    XCTAssertNotNil(jsonSchema);
    
    DSJSONSchema *systemSchema = [DSJSONSchema systemSchemaRemoveAdditional:NO];
    XCTAssertNotNil(systemSchema);
}

- (void)testLoadingSchemasWithRemoveAdditional {
    DSJSONSchema *jsonSchema = [DSJSONSchema jsonSchemaRemoveAdditional:YES];
    XCTAssertNotNil(jsonSchema);
    
    DSJSONSchema *systemSchema = [DSJSONSchema systemSchemaRemoveAdditional:YES];
    XCTAssertNotNil(systemSchema);
}

@end

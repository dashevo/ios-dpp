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
#import <dash_schema_ios/DSValidationResult.h>

/**
 *  Here we test JSON schema draft compatibility with Dash schema patterns
 *  using a simplified inline Dash System schema and later with a single extended DAP schema
 *
 *  Current JSON schema spec is draft #7:
 *  http://json-schema.org/draft-07/schema#
 *
 *  NOTES:
 *
 *  - additionalProperties keyword is used for System and Dap Schema root properties but not for subschemas
 *    this means objects can have additional properties and still validate, therefore the pattern is to ignore
 *    additional properties not specified in the schema in consensus code
 *
 *  - ...we use $ref and definitions section for schema inheritance
 */

@interface DSJsonSchemaTests : XCTestCase

@property (copy, nonatomic) NSDictionary *dapSchemaData;
@property (strong, nonatomic) DSJSONSchema *dapSchema;
@property (copy, nonatomic) NSDictionary *simplifiedSystemSchemaData;
@property (strong, nonatomic) DSJSONSchema *simplifiedSystemSchema;
@property (copy, nonatomic) NSDictionary *data;

@end

@implementation DSJsonSchemaTests

- (NSDictionary *)dapSchemaData {
    if (!_dapSchemaData) {
        NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:@"simplified-dap-schema"
                                                              withExtension:@"json"
                                                               subdirectory:nil];
        NSParameterAssert(url);

        NSData *data = [NSData dataWithContentsOfURL:url];
        NSParameterAssert(data);

        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)kNilOptions error:NULL];
        NSParameterAssert(json);

        _dapSchemaData = json;
    }
    return _dapSchemaData;
}

- (DSJSONSchema *)dapSchema {
    if (!_dapSchema) {
        NSError *error = nil;
        _dapSchema = [DSJSONSchema dashCustomSchemaWithObject:self.dapSchemaData
                                             removeAdditional:NO
                                                        error:&error];
        NSAssert(!error, @"Invalid schema");
    }
    return _dapSchema;
}

- (NSDictionary *)simplifiedSystemSchemaData {
    if (!_simplifiedSystemSchemaData) {
        NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:@"simplified-system-schema"
                                                              withExtension:@"json"
                                                               subdirectory:nil];
        NSParameterAssert(url);

        NSData *data = [NSData dataWithContentsOfURL:url];
        NSParameterAssert(data);

        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)kNilOptions error:NULL];
        NSParameterAssert(json);

        _simplifiedSystemSchemaData = json;
    }
    return _simplifiedSystemSchemaData;
}

- (DSJSONSchema *)simplifiedSystemSchema {
    if (!_simplifiedSystemSchema) {
        NSError *error = nil;
        _simplifiedSystemSchema = [DSJSONSchema dashCustomSchemaWithObject:self.simplifiedSystemSchemaData
                                                          removeAdditional:NO
                                                                     error:&error];
        NSAssert(!error, @"Invalid schema");
    }
    return _simplifiedSystemSchema;
}

- (NSDictionary *)data {
    if (!_data) {
        NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:@"jsonschema-test-data"
                                                              withExtension:@"json"
                                                               subdirectory:nil];
        NSParameterAssert(url);

        NSData *data = [NSData dataWithContentsOfURL:url];
        NSParameterAssert(data);

        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)kNilOptions error:NULL];
        NSParameterAssert(json);

        _data = json;
    }
    return _data;
}

- (void)testSystemSchemaValidInheritedSysObject {
    NSDictionary *object = self.data[@"valid_inherited_sys_object"];
    DSValidationResult *result = [self validateObject:object dapSchema:nil];
    XCTAssertTrue(result.valid);
}

- (void)testSystemSchemaMissingRequiredField {
    NSDictionary *object = self.data[@"missing_required_field"];
    DSValidationResult *result = [self validateObject:object dapSchema:nil];
    XCTAssertFalse(result.valid);
}

- (void)testSystemSchemaMissingRequiredFieldInSuper {
    NSDictionary *object = self.data[@"missing_required_field_in_super"];
    DSValidationResult *result = [self validateObject:object dapSchema:nil];
    XCTAssertFalse(result.valid);
}

- (void)testSystemSchemaMissingRequiredFieldInBase {
    NSDictionary *object = self.data[@"missing_required_field_in_base"];
    DSValidationResult *result = [self validateObject:object dapSchema:nil];
    XCTAssertFalse(result.valid);
}

- (void)testSystemSchemaNoValidSchema {
    NSDictionary *object = self.data[@"no_valid_schema"];
    DSValidationResult *result = [self validateObject:object dapSchema:nil];
    XCTAssertFalse(result.valid);
}

- (void)testSystemSchemaPreventAdditionalPropertiesInMainSysSchema {
    NSDictionary *object = self.data[@"additional_properties_in_main_schema"];
    DSValidationResult *result = [self validateObject:object dapSchema:nil];
    XCTAssertFalse(result.valid);
}

- (void)testSystemSchemaAllowAdditionalPropertiesInSysSubschemas {
    NSDictionary *object = self.data[@"additional_properties_is_sys_subschema"];
    DSValidationResult *result = [self validateObject:object dapSchema:nil];
    XCTAssertTrue(result.valid);
}

- (void)testSystemSchemaContainersValidContainer {
    NSDictionary *object = self.data[@"valid_container"];
    DSValidationResult *result = [self validateObject:object dapSchema:nil];
    XCTAssertTrue(result.valid);
}

- (void)testSystemSchemaContainersMissingList {
    NSDictionary *object = self.data[@"missing_list"];
    DSValidationResult *result = [self validateObject:object dapSchema:nil];
    XCTAssertFalse(result.valid);
}

- (void)testSystemSchemaContainersNullList {
    NSDictionary *object = self.data[@"null_list"];
    DSValidationResult *result = [self validateObject:object dapSchema:nil];
    XCTAssertFalse(result.valid);
}

- (void)testSystemSchemaContainersEmptyList {
    NSDictionary *object = self.data[@"empty_list"];
    DSValidationResult *result = [self validateObject:object dapSchema:nil];
    XCTAssertFalse(result.valid);
}

- (void)testSystemSchemaContainersIncorrectItemType {
    NSDictionary *object = self.data[@"incorrect_item_type"];
    DSValidationResult *result = [self validateObject:object dapSchema:nil];
    XCTAssertFalse(result.valid);
}

- (void)testSystemSchemaContainersMissingArrayItemRequiredField {
    NSDictionary *object = self.data[@"missing_array_item_required_field"];
    DSValidationResult *result = [self validateObject:object dapSchema:nil];
    XCTAssertFalse(result.valid);
}

- (void)testSystemSchemaContainersMissingArrayItemRequiredBaseField {
    NSDictionary *object = self.data[@"missing_array_item_required_base_field"];
    DSValidationResult *result = [self validateObject:object dapSchema:nil];
    XCTAssertFalse(result.valid);
}

- (void)testSystemSchemaContainersPreventMultipleSubschemaTypeDefinitions {
    NSDictionary *object = self.data[@"prevent_multiple_subschematype_definitions"];
    DSValidationResult *result = [self validateObject:object dapSchema:nil];
    XCTAssertFalse(result.valid);
}

- (void)testSystemSchemaContainersPreventDuplicateItems {
    NSDictionary *object = self.data[@"prevent_duplicate_items"];
    DSValidationResult *result = [self validateObject:object dapSchema:nil];
    XCTAssertFalse(result.valid);
}

- (void)testDapContractSchemaValidDapContractObject {
    // TODO: fix me (same as in Android Dash Schema)
    NSDictionary *object = self.data[@"valid_dapcontract_object"];
    DSValidationResult *result = [self validateObject:object dapSchema:self.dapSchema];
    XCTAssertTrue(result.valid);
}

- (void)testDapContractSchemaMissingRequiredField {
    NSDictionary *object = self.data[@"dapobject_missing_required_field"];
    DSValidationResult *result = [self validateObject:object dapSchema:self.dapSchema];
    XCTAssertFalse(result.valid);
}

- (void)testDapContractSchemaMissingRequiredFieldInSuper {
    NSDictionary *object = self.data[@"dapobject_missing_required_field_in_super1"];
    DSValidationResult *result = [self validateObject:object dapSchema:self.dapSchema];
    XCTAssertFalse(result.valid);
}

- (void)testDapContractSchemaMissingRequiredFieldInBase {
    NSDictionary *object = self.data[@"dapobject_missing_required_field_in_base"];
    DSValidationResult *result = [self validateObject:object dapSchema:self.dapSchema];
    XCTAssertFalse(result.valid);
}

- (void)testDapContractSchemaPreventAdditionalPropertiesInMainDapContractSchema {
    NSDictionary *object = self.data[@"prevent_additional_properties_in_main_dapcontract_schema"];
    DSValidationResult *result = [self validateObject:object dapSchema:self.dapSchema];
    XCTAssertFalse(result.valid);
}

- (void)testDapContractSchemaAllowAdditionalPropertiesInDapContractSubSchemas {
    // TODO: fix me (same as in Android Dash Schema)
    NSDictionary *object = self.data[@"allow_additional_properties_in_dapcontract_subschemas"];
    DSValidationResult *result = [self validateObject:object dapSchema:self.dapSchema];
    XCTAssertTrue(result.valid);
}

- (void)testDapContractObjectContainerValid {
    NSDictionary *object = self.data[@"dapcontract_object_container"];
    DSValidationResult *result1 = [self validateObject:object dapSchema:nil];
    XCTAssertTrue(result1.valid);
    
    // TODO: fix me (same as in Android Dash Schema)
    DSValidationResult *result2 = [self validateDapObjectAgainstDapSchema:object dapObjectIndex:0];
    XCTAssertTrue(result2.valid);
}

- (void)testDapContractObjectContainerMissingList {
    NSDictionary *object = self.data[@"dapcontract_missing_list"];
    DSJSONSchema *schema = [DSJSONSchema systemSchemaRemoveAdditional:NO];
    NSError *error = nil;
    [schema validateObject:object withError:&error];
    XCTAssertNotNil(error);
}

- (void)testDapContractObjectContainerEmptyList {
    NSDictionary *object = self.data[@"dapcontract_empty_list"];
    DSJSONSchema *schema = [DSJSONSchema systemSchemaRemoveAdditional:NO];
    NSError *error = nil;
    [schema validateObject:object withError:&error];
    XCTAssertNotNil(error);
}

- (void)testDapContractObjectContainerIncorrectItemType {
    NSDictionary *object = self.data[@"dapcontract_incorrect_item_type"];
    DSValidationResult *result1 = [self validateObject:object dapSchema:nil];
    XCTAssertTrue(result1.valid);
    
    DSValidationResult *result2 = [self validateDapObjectAgainstDapSchema:object dapObjectIndex:0];
    XCTAssertFalse(result2.valid);
}

- (void)testDapContractObjectContainerMissingArrayItemRequiredField {
    NSDictionary *object = self.data[@"dapcontract_missing_array_item_required_field"];
    DSValidationResult *result1 = [self validateObject:object dapSchema:nil];
    XCTAssertTrue(result1.valid);
    
    DSValidationResult *result2 = [self validateDapObjectAgainstDapSchema:object dapObjectIndex:0];
    XCTAssertFalse(result2.valid);
}

- (void)testDapContractObjectContainerMissingArrayItemRequiredBaseField {
    NSDictionary *object = self.data[@"dapcontract_missing_array_item_required_base_field"];
    DSValidationResult *result1 = [self validateObject:object dapSchema:nil];
    XCTAssertFalse(result1.valid);
    
    DSValidationResult *result2 = [self validateDapObjectAgainstDapSchema:object dapObjectIndex:0];
    XCTAssertFalse(result2.valid);
}

- (void)testDapContractObjectContainerPreventMultipleSubSchemaTypeDefinitions {
    NSDictionary *object = self.data[@"dapcontract_prevent_multiple_subschematype_definitions"];
    DSValidationResult *result1 = [self validateObject:object dapSchema:nil];
    XCTAssertTrue(result1.valid);
    
    // TODO: fix me (same as in Android Dash Schema)
    DSValidationResult *result2 = [self validateDapObjectAgainstDapSchema:object dapObjectIndex:0];
    XCTAssertTrue(result2.valid);
    
    DSValidationResult *result3 = [self validateDapObjectAgainstDapSchema:object dapObjectIndex:1];
    XCTAssertFalse(result3.valid);
}

- (void)testDapContractObjectContainerPreventAdditionalItemTypes {
    NSDictionary *object = self.data[@"dapcontract_prevent_additional_item_types"];
    DSValidationResult *result1 = [self validateObject:object dapSchema:nil];
    XCTAssertTrue(result1.valid);
    
    DSValidationResult *result2 = [self validateDapObjectAgainstDapSchema:object dapObjectIndex:0];
    XCTAssertFalse(result2.valid);
}

- (void)testDapContractObjectContainerPreventDuplicateItems {
    NSDictionary *object = self.data[@"dapcontract_prevent_duplicate_items"];
    DSValidationResult *result1 = [self validateObject:object dapSchema:nil];
    XCTAssertFalse(result1.valid);
    
    // TODO: fix me (same as in Android Dash Schema)
    DSValidationResult *result2 = [self validateDapObjectAgainstDapSchema:object dapObjectIndex:0];
    XCTAssertTrue(result2.valid);
    
    // TODO: fix me (same as in Android Dash Schema)
    DSValidationResult *result3 = [self validateDapObjectAgainstDapSchema:object dapObjectIndex:1];
    XCTAssertTrue(result3.valid);
}

- (void)testSysmodContainerValid {
    NSDictionary *object = self.data[@"sysmod_container_valid"];
    DSValidationResult *result = [self validateObject:object dapSchema:nil];
    XCTAssertTrue(result.valid);
}

#pragma mark - Private

- (DSValidationResult *)validateObject:(NSDictionary *)object dapSchema:(nullable DSJSONSchema *)dapSchema {
    DSJSONSchema *schema = dapSchema ?: self.simplifiedSystemSchema;

    NSError *error = nil;
    [schema validateObject:object withError:&error];

    if (error) {
        return [[DSValidationResult alloc] initWithError:error objType:nil propName:nil schemaName:nil];
    }
    else {
        return [[DSValidationResult alloc] initAsValid];
    }
}

- (DSValidationResult *)validateDapObjectAgainstDapSchema:(NSDictionary *)object dapObjectIndex:(NSUInteger)dapObjectIndex {
    NSDictionary *dapObjectContainer = object[@"dapobjectcontainer"];
    NSParameterAssert(dapObjectContainer);
    NSArray *dapObjects = dapObjectContainer[@"dapobjects"];
    NSParameterAssert(dapObjects);
    NSDictionary *dapObject = dapObjects[dapObjectIndex];
    NSParameterAssert(dapObject);

    NSError *error = nil;
    [self.dapSchema validateObject:dapObject withError:&error];

    if (error) {
        return [[DSValidationResult alloc] initWithError:error
                                                 objType:nil
                                                propName:nil
                                              schemaName:nil];
    }
    else {
        return [[DSValidationResult alloc] initAsValid];
    }
}

@end

//
//  DSDAPObjectsFactory.m
//  DSJSONSchemaValidation
//
//  Created by Andrew Podkovyrin on 14/03/2019.
//

#import "DSDAPObjectsFactory.h"

#import "DSSchemaObject.h"

NS_ASSUME_NONNULL_BEGIN

@implementation DSDAPObjectsFactory

+ (NSMutableDictionary<NSString *, id> *)createDAPObjectForTypeName:(NSString *)typeName {
    NSParameterAssert(typeName);
    
    NSMutableDictionary<NSString *, id> *object = [NSMutableDictionary dictionary];
    object[DS_OBJTYPE] = typeName;
    object[@"idx"] = @0;
    object[DS_REV] = @0;
    object[DS_ACT] = @(DS_CREATE_OBJECT_ACTION);
    return object;
}

@end

NS_ASSUME_NONNULL_END

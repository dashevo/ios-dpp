#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "DSJSONSchema+DashSchema.h"
#import "DSSchemaStorage.h"
#import "DSValidationResult.h"
#import "NSBundle+DSDashSchema.h"

FOUNDATION_EXPORT double dash_schema_iosVersionNumber;
FOUNDATION_EXPORT const unsigned char dash_schema_iosVersionString[];


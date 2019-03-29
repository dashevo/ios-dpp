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

#import "NSString+DPUtils.h"

NS_ASSUME_NONNULL_BEGIN

static const UniChar DPBase58chars[] = {
    '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'N', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'm', 'n',
    'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
};

static void * _Nullable DPSecureAllocate(CFIndex allocSize, CFOptionFlags hint, void *info)
{
    void *ptr = malloc(sizeof(CFIndex) + allocSize);
    
    if (ptr) { // we need to keep track of the size of the allocation so it can be cleansed before deallocation
        *(CFIndex *)ptr = allocSize;
        return (CFIndex *)ptr + 1;
    }
    else return NULL;
}

static void DPSecureDeallocate(void *ptr, void *info)
{
    CFIndex size = *((CFIndex *)ptr - 1);
    
    if (size) {
        memset(ptr, 0, size);
        free((CFIndex *)ptr - 1);
    }
}

static void *DPSecureReallocate(void *ptr, CFIndex newsize, CFOptionFlags hint, void *info)
{
    // There's no way to tell ahead of time if the original memory will be deallocted even if the new size is smaller
    // than the old size, so just cleanse and deallocate every time.
    void *newptr = DPSecureAllocate(newsize, hint, info);
    CFIndex size = *((CFIndex *)ptr - 1);
    
    if (newptr && size) {
        memcpy(newptr, ptr, (size < newsize) ? size : newsize);
        DPSecureDeallocate(ptr, info);
    }
    
    return newptr;
}

CFAllocatorRef DPSecureAllocator()
{
    static CFAllocatorRef alloc = NULL;
    static dispatch_once_t onceToken = 0;
    
    dispatch_once(&onceToken, ^{
        CFAllocatorContext context;
        
        context.version = 0;
        CFAllocatorGetContext(kCFAllocatorDefault, &context);
        context.allocate = DPSecureAllocate;
        context.reallocate = DPSecureReallocate;
        context.deallocate = DPSecureDeallocate;
        
        alloc = CFAllocatorCreate(kCFAllocatorDefault, &context);
    });
    
    return alloc;
}

@implementation NSString (DPUtils)

+ (nullable NSString *)dp_base58WithData:(NSData *)d {
    if (! d) return nil;
    
    size_t i, z = 0;
    
    while (z < d.length && ((const uint8_t *)d.bytes)[z] == 0) z++; // count leading zeroes
    
    uint8_t buf[(d.length - z)*138/100 + 1]; // log(256)/log(58), rounded up
    
    memset(buf, 0, sizeof(buf));
    
    for (i = z; i < d.length; i++) {
        uint32_t carry = ((const uint8_t *)d.bytes)[i];
        
        for (size_t j = sizeof(buf); j > 0; j--) {
            carry += (uint32_t)buf[j - 1] << 8;
            buf[j - 1] = carry % 58;
            carry /= 58;
        }
        
        memset(&carry, 0, sizeof(carry));
    }
    
    i = 0;
    while (i < sizeof(buf) && buf[i] == 0) i++; // skip leading zeroes
    
    CFMutableStringRef s = CFStringCreateMutable(DPSecureAllocator(), z + sizeof(buf) - i);
    
    while (z-- > 0) CFStringAppendCharacters(s, &DPBase58chars[0], 1);
    while (i < sizeof(buf)) CFStringAppendCharacters(s, &DPBase58chars[buf[i++]], 1);
    memset(buf, 0, sizeof(buf));
    return CFBridgingRelease(s);
}

@end

NS_ASSUME_NONNULL_END

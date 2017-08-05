//
//  AAFDevice.m
//  AAFingerprint
//
//  Created by dev-aozhimin on 2017/8/5.
//  Copyright © 2017年 aozhimin. All rights reserved.
//

#import "AAFDevice.h"
#include <sys/sysctl.h>
#import <UIKit/UIDevice.h>

static inline NSString *AAFGetSysCtlStrBySpecifier(char* specifier) {
    size_t size = -1;
    char *val;
    NSString *result = @"";
    
    if (!specifier || strlen(specifier) == 0 ||
        sysctlbyname(specifier, NULL, size, NULL, 0) == -1 || size == -1) {
        return false;
    }
    
    val = (char*)malloc(size);
    
    if (sysctlbyname(specifier, val, &size, NULL, 0) == -1)
    {
        free(val);
        return result;
    }
    
    result = [NSString stringWithUTF8String:val];
    free(val);
    return result;
}

@implementation AAFDevice
@synthesize systemVersionCode = _systemVersionCode;
@synthesize hardwareModel     = _hardwareModel;
@synthesize systemVersion     = _systemVersion;

+ (instancetype)currentDevice {
    static AAFDevice *_currentDevice;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _currentDevice = [[self alloc] init];
    });
    return _currentDevice;
}

- (NSString *)systemVersionCode {
    if (!_systemVersionCode) {
        size_t size;
        sysctlbyname("kern.osversion", NULL, &size, NULL, 0);
        char *osVersion = malloc(size * sizeof(char));
        if (sysctlbyname("kern.osversion", osVersion, &size, NULL, 0) != -1) {
            _systemVersionCode = [NSString stringWithUTF8String:osVersion];
            free(osVersion);
        } else {
            _systemVersionCode = @"";
        }
    }
    
    return _systemVersionCode;
}

- (NSString *)hardwareModel {
    if (!_hardwareModel) {
        _hardwareModel = AAFGetSysCtlStrBySpecifier("hw.machine");
    }
    return _hardwareModel;
}

- (NSString *)systemVersion {
    if (!_systemVersion) {
        _systemVersion = [[UIDevice currentDevice] systemVersion];
    }
    return _systemVersion;
}

+ (NSString *)hardwareFingerPrint {
    return @"";
}

@end

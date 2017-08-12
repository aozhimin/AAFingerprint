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
#import <CommonCrypto/CommonDigest.h>

static inline NSString *AAFGetSysCtlStrBySpecifier(char* specifier) {
    size_t size = -1;
    char *val;
    NSString *result = @"";
    
    if (!specifier || strlen(specifier) == 0 ||
        sysctlbyname(specifier, NULL, &size, NULL, 0) == -1 || size == -1) {
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
@synthesize totalDiskSpace    = _totalDiskSpace;
@synthesize systemBootTime    = _systemBootTime;

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

- (NSNumber *)totalDiskSpace {
    if (!_totalDiskSpace) {
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory()
                                                                                               error:nil];
        _totalDiskSpace = [fileAttributes objectForKey:NSFileSystemSize];
    }
    return _totalDiskSpace;
}

+ (uint64_t)totalMemeory {
    return [NSProcessInfo processInfo].physicalMemory;
}

+ (NSString *)languageList {
    return [[NSLocale preferredLanguages] componentsJoinedByString:@","];
}

- (NSDate *)systemBootTime {
    if (!_systemBootTime) {
        struct timeval bootTime;
        size_t len = sizeof(bootTime);
        int mib[2] = {CTL_KERN, KERN_BOOTTIME};
        
        if(sysctl(mib, sizeof(mib) / sizeof(*mib), &bootTime, &len, NULL, 0) >= 0) {
            _systemBootTime = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)bootTime.tv_sec];
        }
    }
    return _systemBootTime;
}

+ (NSString *)deviceFingerPrint {
    AAFDevice *device              = [AAFDevice currentDevice];
    NSString *characteristicString = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@",
                                      device.systemVersionCode,
                                      device.hardwareModel,
                                      device.systemVersion,
                                      [device totalDiskSpace],
                                      @([self totalMemeory]),
                                      [device systemBootTime],
                                      [self languageList],
                                      [NSTimeZone systemTimeZone].name,
                                      [[NSLocale autoupdatingCurrentLocale] localeIdentifier]];
    NSString *sha1                 = [device sha1StringWithString:characteristicString];
    NSString *deviceFingerPrint  = [NSString stringWithFormat:@"v1_%@", sha1.uppercaseString];
    return deviceFingerPrint;
}

#pragma mark - Helper

- (NSString *)sha1StringWithString:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *sha1String = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [sha1String appendFormat:@"%02x", digest[i]];
    }
    
    return sha1String;
}

@end

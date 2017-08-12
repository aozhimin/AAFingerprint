//
//  AAFDevice.h
//  AAFingerprint
//
//  Created by dev-aozhimin on 2017/8/5.
//  Copyright © 2017年 aozhimin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Get the device fingerprint class
 */
@interface AAFDevice : NSObject

/**
 iOS system kernel version code
 */
@property (nonatomic, copy, readonly            ) NSString     *systemVersionCode;

/**
 iOS system version, same as systemVersion of `UIDevice`
 */
@property (nonatomic, copy, readonly            ) NSString     *systemVersion;

/**
 The iphone hardware model, refer to `hw.machine` of <sys/sysctl.h> file
 */
@property (nonatomic, copy, readonly            ) NSString     *hardwareModel;

/**
 The total space of disk
 */
@property (nonatomic, strong, readonly          ) NSNumber     *totalDiskSpace;

/**
 System startup time
 */
@property (nonatomic, strong, readonly, nullable) NSDate       *systemBootTime;

+ (instancetype)currentDevice;

/**
 Get the device fingerprint, which is based on the device's Characteristic data

 @return device fingerprint
 */
+ (NSString *)hardwareFingerPrint;

@end
NS_ASSUME_NONNULL_END

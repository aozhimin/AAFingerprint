//
//  AAFDevice.h
//  AAFingerprint
//
//  Created by dev-aozhimin on 2017/8/5.
//  Copyright © 2017年 aozhimin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface AAFDevice : NSObject

@property (nonatomic, copy, readonly            ) NSString     *systemVersionCode;

@property (nonatomic, copy, readonly            ) NSString     *systemVersion;

@property (nonatomic, copy, readonly            ) NSString     *hardwareModel;

@property (nonatomic, strong, readonly          ) NSNumber     *totalDiskSpace;

@property (nonatomic, strong, readonly, nullable) NSDate       *systemBootTime;

+ (instancetype)currentDevice;

+ (NSString *)hardwareFingerPrint;

@end
NS_ASSUME_NONNULL_END

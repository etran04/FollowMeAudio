//
//  DeviceInfo.h
//  FCPlayer
//
//  Created by Seonman Kim on 12/24/14.
//  Copyright (c) 2014 Harman International. All rights reserved.
//

#ifndef FCPlayer_DeviceStatus_h
#define FCPlayer_DeviceStatus_h

#import <Foundation/Foundation.h>


@interface DeviceInfo : NSObject

/*! The device id */
@property (nonatomic, readonly) long long deviceId;

/*! The device name */
@property (nonatomic, copy, readonly) NSString *deviceName;

/*! The IP address of the speaker */
@property (nonatomic, copy, readonly) NSString *ipAddress;

/*! The port number of the speaker */
@property (nonatomic, readonly) NSInteger port;

/*! The ID of the group that the speaker belongs to */
@property (nonatomic, readonly) long long groupId;

/*! The role of the speaker */
@property (nonatomic, readonly) NSInteger role;

/*! The name of the group that the speaker belongs to */
@property (nonatomic, copy, readonly) NSString *groupName;

/*! The model name of the speaker */
@property (nonatomic, copy, readonly) NSString *modelName;

/*! The zone name of the speaker. The zone name is used for representing group ID and group name in a single string, separated by '#&#' */
@property (nonatomic, copy, readonly) NSString *zoneName;

/*! The current volume level of the speaker */
@property (nonatomic, readonly) NSInteger volume;

/*! Indicates if the speaker is active (added to the current playback session) */
@property (nonatomic, readonly) BOOL active;

/*! The firmware version of the speaker */
@property (nonatomic, copy, readonly) NSString *version;

/*! The mac address of the speaker */
@property (nonatomic, copy, readonly) NSString *macAddress;

/*! The wifi signal strength of the speaker. This value changes over time. */
@property (nonatomic, readonly)  NSInteger wifiSignalStrength;

/*! balace value in stereo mode. The value range from -6 to 6, 0 is neutral. */
@property (nonatomic, readonly) NSInteger balance;

/*! Indicates whether the speaker is playing, regardless of the source */
@property (nonatomic, readonly) BOOL isPlaying;

/*! The channleType: 1 is stereo, etc. */
@property (nonatomic, readonly) NSInteger channelType;

/*! Indicates whether the speaker is the master in stereo or group mode. 1 if the speaker is standalone. */
@property (nonatomic, readonly) BOOL isMaster;

@end

#endif

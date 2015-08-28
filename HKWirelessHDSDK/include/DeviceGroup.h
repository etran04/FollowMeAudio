//
//  DeviceGroup.h
//  HKSamplePlayer
//
//  Created by Seonman Kim on 1/29/15.
//  Copyright (c) 2015 Harman International. All rights reserved.
//

#ifndef FCPlayer_DeviceGroup_h
#define FCPlayer_DeviceGroup_h

#import <Foundation/Foundation.h>

@interface DeviceGroup : NSObject

/*! The list of devices that belong to the group */
@property (nonatomic, copy, readonly) NSMutableArray *deviceList;

/*! The group name. */
@property (nonatomic, copy, readonly) NSString *groupName;

/*! The group ID */
@property (nonatomic, readonly) long long groupId;

/*! The active status indicating whether the speaker is added to the current session for playback. */
@property (nonatomic, readonly) BOOL active;

@end

#endif
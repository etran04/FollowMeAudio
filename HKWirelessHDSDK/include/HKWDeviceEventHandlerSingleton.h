//
//  HKWDeviceEventHandlerSingleton.h
//  HKPage
//
//  Created by Seonman Kim on 4/14/15.
//  Copyright (c) 2015 Harman International. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HKWDeviceEventHandlerSingleton;

@protocol HKWDeviceEventHandlerDelegate <NSObject>

@required

/*!
 * @brief Invoked when some of device information have been changed for any speakers.It is also invoked when the network is disconnected ans no speakers are available any longer, or when the network becomes up from down, so speakers in the network become added to the HKWirelessHD network. <p>The information monitored includes device status (active or inactive), model name, group name, and wifi signal strengths.<p>Volume change does not trigger this call. The volume update is reported by CallbackVolumeLevelChanged.
 * @param deviceId the deviceId of the speaker
 * @param reason the reason code about the updated status
 */
-(void)hkwDeviceStateUpdated:(long long)deviceId withReason:(NSInteger)reason;

/*!
 * @brief Invoked when an error occures.
 * @param errorCode an integer value indicating error code.
 * @param errorMesg a string value containing a description about the error.
 */
-(void)hkwErrorOccurred:(NSInteger)errorCode withErrorMessage:(NSString*)errorMesg;

@end


@interface HKWDeviceEventHandlerSingleton : NSObject

+(HKWDeviceEventHandlerSingleton*)sharedInstance;

@property (nonatomic, weak) id<HKWDeviceEventHandlerDelegate> delegate;

@end

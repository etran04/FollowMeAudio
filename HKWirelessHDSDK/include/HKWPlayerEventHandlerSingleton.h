//
//  HKWPlayerEventHandlerSingleton.h
//  HKPage
//
//  Created by Seonman Kim on 4/16/15.
//  Copyright (c) 2015 Harman International. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HKWControlHandler.h"

@class HKWPlayerEventHandlerSingleton;

@protocol HKWPlayerEventHandlerDelegate <NSObject>

@required
/*!
 * @brief Invoked when the current playback is ended.
 */
-(void)hkwPlayEnded;

@optional

/*!
 * @brief Invoked when volume level has been changed for any spekaers.
 * @param deviceId the device unique ID (long long type)
 * @param deviceVolume the volume level of the device (speaker)
 * @param avgVolume the average volume level
 */
-(void)hkwDeviceVolumeChanged:(long long)deviceId deviceVolume:(NSInteger)deviceVolume withAverageVolume:(NSInteger)avgVolume;

/*!
 * @brief Invoked when player state has been changed during the playback.
 * @param playState The player state
 */
-(void)hkwPlaybackStateChanged:(HKPlayerState)playState;

/*!
 * @brief Invoked when the current time of playback has been changed. It is called every one second.
 * @param timeElapsed the time (in second) passed since the beginning of the playback.
 */
-(void)hkwPlaybackTimeChanged:(NSInteger)timeElapsed;

@end


@interface HKWPlayerEventHandlerSingleton : NSObject

+(HKWPlayerEventHandlerSingleton*)sharedInstance;

@property (nonatomic, weak) id<HKWPlayerEventHandlerDelegate> delegate;

@end

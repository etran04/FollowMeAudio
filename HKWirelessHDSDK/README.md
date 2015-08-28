# HKWirelessHDSDK

SDK Documentations are available at http://harmandeveloperdocs.readthedocs.org/

----
## Release Notes (v1.2) - 7/9/2015
### Features
* added playStreamingMedia : play web streaming, such as http:, rtsp:, etc.
* added mute(), unmute(), isMuted()
* added isDeviceAvailable()
* added "withSpeakersAdded:" parameter in initializeHKWControlHandler()


## Release Notes (v1.1.1) - 6/2/2015
### Bug Fixes
* A bug that hkTimeElapsed() does not stop even the playback is over has been fixed.


## Release Notes (v1.1)
### Features
* Replaced the callbacks with Delegate protocols, HKWDeviceEventHandlerDelegate and HKWPlayerEventHandlerDelegate.
  - The following callbacks are replaced:
    - registerCallbackDevicesStateUpdated() -> hkwDeviceStateUpdated() in HKWDeviceEventHandlerDelegate.h
    - registerCallbackErrorOccurred() -> hkwErrorOccurred() in HKWDeviceEventHandlerDelegate.h
    - registerCallbackVolumeLevelChanged() -> hkwDeviceVolumeChanged() in HKWPlayerEventHandlerDelegate.h
    - registerCallbackPlaybackStateChanged() -> hkwPlaybackStateChanged() in HKWPlayerEventHandlerDelegate.h
    - registerCallbackPlayEnded() -> hkwPlayEnded() in HKWPlayerEventHandlerDelegate.h
    - registerCallbackPlaybackTimeChanged() -> hkwPlaybackTimeChanged() in HKWPlayerEventHandlerDelegate.h
    

## Release Notes (v1.0)

### Features
* Support HK Wireless HD Audio streaming
* Support multiple speakers, multiple rooms audio streaming
* Speaker managements
  - change the volume level
  - view or change speaker name
  - view the model name and the firmware version of the speaker
  - view or change group that the speaker belongs to
  - add or remove speakers from/to playback session
  - view the current WiFi signal strength and IP address
  - view if the speaker is playing or not
  - callbacks for speaker status updates


* Please refer to HKWControlHandler.h, DeviceInfo.h and DeviceGroup.h for more information on the APIs.

* Also, please refer to Getting Started Guide for jumpstart to create your own apps.

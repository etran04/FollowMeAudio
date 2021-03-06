#FOLLOW ME AUDIO
Integrate iBeacons with HKWireless SDK in order to ultimately create "Follow Me Audio"

##WHAT IT DOES

Follow Me Audio is proximity based audio playback using iBeacons with the Harman SDK. It allows for continious audio playback from location to location. The idea is to place iBeacons within or near Harman OMNI speakers, and then have the iPhone keep track of each iBeacon and adjust audio playback, based on the user's location from each iBeacon. 

A use case for this would be to have one speaker in different rooms of a house, all on the same network, and as you enter a room, your music/audio book/etc, will start playing automatically. As you leave a room, the speaker will go quiet in that room. 

##CURRENT FUNCTIONALITY
- Able to start wake up from sleep and start playing music when in 'Near' or 'Immediate' vicinity of either speakers. 
- When 'Far' or 'Unknown', volume of associated speaker will fade out to 0.

> Note: These are the core functionality of the project. Will add more when I can think of it. 

##VIDEO
Click [here](https://www.youtube.com/watch?v=SqSm9mkGPmo) for a interactive Youtube demo showing how to set up and use FollowMeAudio as well as a quick video of using it in the office towards the end. 

##CHALLENGES I FACED
The most difficult part of this project was a feature I haven't finished implementing. I wanted to find a way to handle volume control based on the distance of the user from the iBeacon associated with a speaker. The issue is iBeacons are meant to be used as proximity sensors and not as exact indoor distance indicators, so there had be some form of approximation involved to implement this. I attempted to do this initially with linear regression but that did not work due to the sporadic behavior of the iBeacons. I recently attempted nonlinear approximation through Levenberg-Marquardt algorithm (trying to use [Cere's Solver](http://ceres-solver.org/index.html), Google's Framework for solving large, complicated optimization problems), but it has been difficult to implement, so I have tabled it for now. 

Other difficulties I encountered while developing this app are as followed:
- I had to use two different kinds of brands of beacon. For some reason, the beacons did not produce the same range of RSSI values when in the same proximity. This means the beacons I used required specific placements so that a beacon's radius for Near/Immediate does not conflict another's radius. 
- Initially the app worked only with hardcoded speakers-to-beacon pairs. That was really inefficient in that it didn't allow for any use outside of a demo. I was able to include a "Pair Speaker" feature where you click on a beacon, then assign a speaker to it, which fixed that issue.

##ACCOMPLISHMENTS I AM PROUD OF
The code was originally written in Objective C. Porting it to Swift made it feel more clean and looked asthetically more pleasing. I'm happy to say that if the beacons are placed in prime locations (spread out/not within each other proximity), Follow Me Audio works really well. I'm also happy to say it looks decent for a first iOS project. I really enjoyed working on the front end user interface, such as the color theme, button placement, and how user interaction was handled. There's still plenty to be done, but overall, it was a good experience developing this and playing around with iBeacons and Harman SDK.

##HOW TO USE
For the purpose of this use case, we will be ignoring custom settings (song selection)
<br>This scenario will run the default song (The Hills by The Weeknd)

**Please make sure your Bluetooth is on! iBeacons uses BLE (Bluetooth Low Energy) in order to detect proximity.**

1. Go into app 'FollowMe'
2. Press the '+' sign at the top right corner. 
3. Input beacon information, then press save.
4. See that beacon is registered. Location should be updating. (Repeat for as many beacons as you need)
5. Pair the beacon to a speaker by clicking on the beacon, and then 'Pair Speaker'
6. Select an inactive speaker from the list of speakers. 
7. See that the beacon is paired with the intended speaker.
8. Press the 'settings' icon at the top left corner.
9. Play song when ready. Alert will notify user song is playing. (Now you can move around, room to room, etc)
10. When ready to stop song, go back to 'settings' and press 'stop song'. Alert will notify when song is stopped. 

![Imgur](http://i.imgur.com/7u7zRaw.png)

##FAQs
**Q. What speaker is connected to which beacon?**

Underneath a a Beacon cell contains all the beacon information. The speaker that the beacon is paired with is under "Paired with: ..."

**Q. How do I pair a beacon to a specific speaker?**

When a user clicks on a beacon, an option to 'Pair Speaker' will be available. The user clicks that button and goes to a list of Speakers to select from. You cannot pair a beacon to a speaker that is already active. 

**Q. I got error "PCH was compiled with module cache path". How do I fix it?**

My solution is to delete the 'Derived Data' project in the folder, and do a fresh clean build, then compile.

**Q. How is a beacon paired to a speaker?**

Great question. When a user clicks on "Pair beacon" they are taken to a list of all available speakers on the network. When they click on the speaker, the app takes the speaker's name and stores it in a temporary dictionary of speaker names to a beacon item. 

**Q. I got error "Undefined symbols for architecture x86_64". How do I fix it?

This error occurs because you're trying to run the application on the XCode simulator. The Harman SDK does not support use of the simulator, it must be ran directly on a phone. 

##TO DO LIST
- Implement Levenberg-Marquardt to smooth out RSSI values for volume control based on actual distance 
- Include conditional check for which device it is, and adjust the volume accordingly. (Some devices play louder at the same base volume)
- Fade volume up in instead of going from volume 0 to volume X

##CREDITS
- [Ray Wenderlich](http://www.raywenderlich.com/101891/ibeacons-tutorial-ios-swift) for the wonderful iBeacon tutorial 
- [Harman International] (http://www.developer.harman.com/) for an awesome SDK 
- Icons used in this app are made by [Freepik](http://www.freepik.com/) from [FlatIcon](http://www.flaticon.com/)

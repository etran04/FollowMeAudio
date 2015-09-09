#Follow Me Audio
Integrate iBeacons with HKWireless SDK in order to ultimately create "Follow Me Audio"

WHAT IT DOES
------------
Follow Me Audio is proximity based audio playback using iBeacons with the Harman SDK. It allows for continious audio playback from location to location. The idea is to place iBeacons within or near Harman OMNI speakers, and then have the iPhone keep track of each iBeacon and adjust audio playback, based on the user's location from each iBeacon. 

CURRENT FUNCTIONALITY
---------------------
- Able to start wake up from sleep and start playing music when in 'Near' or 'Immediate' vicinity of either speakers. 
- When 'Far', volume of associated speaker will drop to 0. 

CHALLENGES I FACED
------------------
The most difficult part of this project was a feature I haven't finished implementing. I wanted to find a way to handle volume control based on the distance of the user from the iBeacon associated with a speaker. The issue is iBeacons are meant to be used as proximity sensors and not exact distance indicators, so there had be some form of appoximation involved to implement this. I attempted to do this initially with linear regression but that did not work due to the sporadic behavior of the iBeacons. I recently attempted nonlinear approximation through Levenberg-Marquardt algorithm (through [Cere's Solver](http://ceres-solver.org/index.html), Google's Framework for solving large, complicated optimization problems), but it has been difficult to implement, so I have tabled it for now. 

ACCOMPLISHMENTS I AM PROUD OF
----------------------------
The code was originally written in Objective C. Porting it to Swift made it feel more clean and looked asthetically more pleasing. I'm happy to say that if the beacons are placed in prime locations (spread out/not within each other proximity), Follow Me Audio works really well. I'm also pleased to say I really enjoyed working on the front end user interface, such as the color theme, button placement, and how user interaction was handled. 

HOW TO USE
----------
For the purpose of this use case, we will be ignoring custom settings (volume offset, song selection)
<br>This scenario will run the default song (The Hills by The Weeknd @ volume offset: 0)

<br> 1) Go into app 'FollowMe'
<br> 2) Press the '+' sign at the top right corner. 
<br> 3) Input beacon information, then press save.
<br> 4) See that beacon is registered. Location should be updating. 
<br> 5) Pair the beacon to a speaker by clicking on the beacon, and then 'Pair Speaker'
<br> 6) Select an inactive speaker from the list of speakers. (Chose 'eric' in the diagram)
<br> 7) See that the beacon is paired with the intended speaker.
<br> 8) Press the 'settings' icon at the top left corner.
<br> 9) Play song when ready. Alert will notify user song is playing. 
<br> 10) Stop song when ready. Alert will notify when song is stopped. 

![Imgur](http://i.imgur.com/7u7zRaw.png)

FAQs
----
<b> Q. What speaker is connected to which beacon? </b>

Underneath a a Beacon cell contains all the beacon information. The speaker that the beacon is paired with is under "Paired with: ..."

<b> Q. How do I pair a beacon to a specific speaker? </b>

When a user clicks on a beacon, an option to 'Pair Speaker' will be available. The user clicks that button and goes to a list of Speakers to select from. You cannot pair a beacon to a speaker that is already active. 

<b> Q. I got error "PCH was compiled with module cache path". How do I fix it? </b>

My solution is to delete the 'Derived Data' project in the folder, and do a fresh clean build, then compile.

TO DO LIST
---------
- Implement Levenberg-Marquardt to smooth out RSSI values for volume control based on actual distance 

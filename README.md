#FollowMeAudio
Integrate iBeacons with HKWireless SDK in order to ultimately create "Follow Me Audio"

Currently functionality: 
- Able to start wake up from sleep and start playing music when in 'Near' or 'Immediate' vicinity of either speakers. 
- When 'Far', volume of associated speaker will drop to 0. 
- Implemented a linear regression algorithm. Current taking a set of k data points to calculate a more accurate rssi value to base the new volume off of. Polls for one second after, creating a new best fit line to approximate the next volume level. 

HOW TO USE
----------

For the purpose of this use case, we will be ignoring custom settings (volume offset, song selection)
<br> This scenario will run the default song (The Hills by The Weeknd @ volume offset: 0)

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

DISCLAIMER
---------

Still a work in progress. Would love to figure out some way of smoothing RSSI value out to have a seamless audio control functionality. 

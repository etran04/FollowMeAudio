#FollowMeAudio
Integrate iBeacons with HKWireless SDK in order to ultimately create "Follow Me Audio"

Currently functionality: 
<br> 1) Able to start wake up from sleep and start playing music when in 'Near' or 'Immediate' vicinity of either speakers. 
<br> 2) When 'Far', volume of associated speaker will drop to 0. 
<br> 3) Implemented a linear regression algorithm. Current taking a set of k data points to calculate a more accurate rssi value to base the new volume off of. Polls for one second after, creating a new best fit line to approximate the next volume level. 
<br> 4) In the first k seconds, figures out the average rssi to pick volume to start playing at, rather than wait the entire k seconds.


HOW TO USE
----------

<br> 1) Go into app 'FollowMe'
<br> 2) Press the '+' sign at the top right corner. 
<br> 3) Input beacon information. (name has to match with speaker paired with)
<br> <b> Click 'list of speakers' to see all available speakers on the network. </b> 
<br> 4) See that beacon is registered. Location should be updating. 
<br> 5) Press the 'settings' icon at the top left corner.
<br> 6) Play song when ready. Alert will notify user song is playing. 
<br><b> At this point, you can walk around and see Follow Me in action. </b>
<br> 6) Stop song when ready. Alert will notify when song is stopped. 

![Imgur](http://i.imgur.com/1Xd9HL2.png)

FAQs
----

<b> Q. What speaker is connected to which beacon? </b>

Beacons are paired to speakers based on name. For example, if I would like to pair speaker 'Alex" with a beacon, I'd have to use 'Alex' as the name of the beacon when I input it into the application. 

<b> Q. How do I name my speaker? </b>

Use the HK Page app to name them. (only need to do this if you're connecting the speaker to a new network) This is critical due to the fact that the code is hard coded to look for speakers with the names specified.

On the page app, you should be able to go to the speaker info and change the speaker name. (not to be confused with speaker room) You could set both to be safe if you want.

<b> Q. I got error "PCH was compiled with module cache path". How do I fix it? </b>

My solution is to delete the 'Derived Data' project in the folder, and do a fresh clean build, then compile.

DISCLAIMER
---------

Still a work in progress. Would love to figure out some way of smoothing RSSI value out to have a seamless audio control functionality. 

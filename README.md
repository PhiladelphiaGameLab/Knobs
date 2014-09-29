Knobs
==========

Knobs is one of several demo iOS apps for the [Philadelphia Game Lab](philadelphiagamelab.org)'s  open source 3D Audio library, [Sonic](https://github.com/philadelphiagamelab/Sonic). As with all Sonic apps, Knobs requires headphones.

Knobs is similar to another demo app, [SteerAudio](github.com/philadelphiagamelab/SteerAudio), but rather than use gyroscope input to affect sound, with Knobs the user can move an audio object around by turning two knobs: one for the object's [azimuth](http://en.wikipedia.org/wiki/Azimuth) and a second for the object's [pitch](http://en.wikipedia.org/wiki/Degrees_of_freedom_(mechanics)), both in relation to the user. A third knob may eventually be added to adjust the distance of the audio object from the user, but for now the audio object is fixed on the unit sphere surrounding the user's head. As the user adjust these knobs, the sound changes as if they were actually moving the audio source around their head.

**IMPORTANT**

Because Knobs contains the Sonic library as a git submodule, you'll need to use the `--recursive` flag when cloning, i.e.:

		$> git clone --recursive https://github.com/philadelphiagamelab/SonicDemo.git

Omitting the `--recursive` flag will clone the Knobs repo with an empty Sonic submodule.

#### More info

For a detailed description of the Sonic 3D-Audio project, as well as updates and other information, visit the [Sonic project webpage](sonic.philadelphiagamelab.org). For links to other Sonic demo apps, check out [the Sonic README](https://github.com/PhiladelphiaGameLab/Sonic/blob/master/README.md).
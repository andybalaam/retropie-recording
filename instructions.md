# Recording gameplay videos on RetroPie

> Credits: this is a slightly corrected and shortened version of [How To Record A GamePlay Video From A RetroPie](http://selsine.com/2016/10/15/how-to-record-a-game-play-video-from-a-retropie/) by selsine, which is itself based on [Recording Live Gameplay in RetroPie’s RetroArch Emulators Natively on the Raspberry Pi](https://retroresolution.com/2016/07/06/recording-live-gameplay-in-retropies-retroarch-emulators-natively-on-the-raspberry-pi/) by Retro Resolution.  Andy Balaam's blog post, which was moved to here, is at [artificialworlds.net/blog](https://www.artificialworlds.net/blog/2018/01/07/recording-gameplay-videos-on-retropie/).  This document is a collaboration between multiple contributors - details in the [file history](https://github.com/andybalaam/retropie-recording/commits/master/instructions.md).

[RetroPie](https://retropie.org.uk/) is based on [RetroArch](http://www.retroarch.com/).  RetroArch has a feature to record gameplay videos, but the current version of RetroPie has it disabled, presumably because it was thought to be too intensive to run properly on a Raspberry Pi.

These instructions tell you how to turn the recording feature on, and set it up.  This works perfectly on my Raspberry Pi 3, allowing me to record video and sound from games I am playing.

The code for this is here: [github.com/andybalaam/retropie-recording](https://github.com/andybalaam/retropie-recording) - this was code written by RetroRevolution, with small corrections and additions by me.

Before you start, you should have RetroPie working and connected to the Internet, and updated to the latest version.

**Note:** you should make a backup of your RetroPie before you start, because if you type the command below you could completely break it, meaning you will have to wipe your SD card and start fresh.

## Turning on the recording feature

RetroArch uses the [ffmpeg](https://ffmpeg.org) program to record video.  To turn on recording, we need to log into the Pi using ssh, download and compile ffmpeg, and then recompile RetroArch with recording support turned on.

### Open a command line on the Pi

#### Log in to the Pi using ssh

Find out the IP address of your Pi by choosing "RetroPie setup" in the RetroPie menu and choosing "Show IP Address".  Write down the IP address (four numbers with dots in between - for example: `192.168.0.3`).

On your Linux* computer open a Terminal and type:

```
ssh pi@192.168.0.3
```

(put in the IP address you wrote down instead of 192.168.0.3)

When it asks for your password, type: `raspberry`

If this works right, you should see something like this:
![](//artificialworlds.net/blog/wp-content/uploads/retro-login.png)
(The RetroPie Project joystick logo)

\* if you don't have Linux, this should work OK on a Mac, or on Windows you could try using [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html).

#### Open a command line directly from the Pi

If logging in through SSH is too cumbersome, you can use the command line on RetroPie directly. Just plug a keyboard and a mouse, and you're set.

The easiest way is just to exit EmulationStation: open the menu (start), then "Quit", then "Quit EmulationStation", and you'll be sent to the command line. Once you're done with your commands, just type `reboot` to restart the Pi.

An alternative way is to use the [desktop environment](https://retropie.org.uk/docs/FAQ/#where-did-the-desktop-go) : install it through the Retropie-Setup tool, in Configuration / Tools > Raspbiantools > Install Pixel Desktop Environment. It then adds an entry in the "Ports" section of Retropie, where you can launch the desktop, and from there access a command line, file browser, and anything you like.

### Download and compile ffmpeg

Log in to the RetroPie as described above. The commands shown below should all be typed in to the window where you are logged in to the RetroPie.

Download the script ffmpeg-install.sh by typing this:

```
wget https://github.com/andybalaam/retropie-recording/raw/master/ffmpeg-install.sh
```

Now run it like this:

```
bash ffmpeg-install.sh
```

(Note: DON'T use `sudo` to run this - just type exactly what is written above.)

Now wait a long time for this to work.  If it prints out errors, something went wrong - read what it says, and you may need to edit the ffmpeg-install.sh script to figure out what to do.  Leave a comment and include the errors you saw if you need help.

Hopefully it will end successfully and print:

```
FFmpeg and Codec Installation Complete
```

If so, you are ready to move on to recompiling RetroArch:

### Recompile RetroArch with recording turned on (optional)

Newer versions of RetroArch come with the ability to record gameplay, and you shouldn't have to rebuild it. To check if your version supports recording, open RetroArch (from the main RetroPie menu: Retropie (configuration) > RetroArch) and check if it has an entry in Settings > Recording.

Download the script build-retroarch-with-ffmpeg.sh by typing this:

```
wget https://github.com/andybalaam/retropie-recording/raw/master/build-retroarch-with-ffmpeg.sh
```

Now run it like this:

```
bash build-retroarch-with-ffmpeg.sh
```

It should finish in about 10 minutes, and print:

```
Building RetroArch with ffmpeg enabled complete
```

If it printed that, your RetroPie now has recording support!  Restart your RetroPie:

### Restart the RetroPie

Restart your RetroPie.

If you want to check that recording support is enabled, Look for "Checking FFmpeg Has Been Enabled in RetroArch" on the [RetroResolution guide](https://retroresolution.com/2016/07/06/recording-live-gameplay-in-retropies-retroarch-emulators-natively-on-the-raspberry-pi/#li_rgui_check_recording)

Now you need to set up RetroPie to record your emulator.

## Setting up recording for your emulator

To set up an emulator, you need a general recording config file (the same for all emulators), and a launch config for the actual emulator you are using.

### Create the recording config file

Log into the RetroPie as described in the first section, and type this to download the recording config file.  If you want to change settings like what file format to record in, this is the file you will need to change.

```
wget https://github.com/andybalaam/retropie-recording/blob/master/recording-config.cfg
```

### Check that recording works

You can launch gameplay recording at any time using RetroArch. Try it out before you go any further.

- From the main RetroPie menu > RetroPie (configuration) > RetroArch
- Settings > Configuration > Save Configuration on exit = ON
- Settings > Recording > Record Quality = Custom ; Custom Record Configuration = browse to your `recording-config.cfg` file
- Quit RetroArch
- Launch a game using a Libretro emulator (check that it says "lr-xxx" when launching the game)
- Open the RetroArch menu (hotkey + X button) > Start Recording > play a while > RA menu > Stop Recording
- Exit the game, then open a command line using your preferred method
- Use `ls /home/pi` and check that a video file has been created.

### Create a launch config for your emulator

Each RetroPie emulator has a config file that describes how to launch it.  For example, the NES emulator's version is in /opt/retropie/configs/nes/emulators.cfg.

To get a list of all the emulators, log into your RetroPie and type:

```
ls /opt/retropie/configs
```

In that list you will see, for example, "nes" for the NES emulators, and "gb" for the GameBoy emulators.  Find the one you want to edit, and edit it with the `nano` editor by typing:

```
nano /opt/retropie/configs/gb/emulators.cfg
```

(Instead of "gb" type the right name for the emulator you want to use, from the list you got when you typed the "ls" command above.)

Now you need to add a new line in this file.  Each line describes how to launch an emulator.  You should copy an existing line, and add some more stuff to the end.

For example, my version of this file looks like this:

```
lr-gambatte = "/opt/retropie/emulators/retroarch/bin/retroarch -L /opt/retropie/libretrocores/lr-gambatte/gambatte_libretro.so --config /opt/retropie/configs/gb/retroarch.cfg %ROM%"
<span style="color: green;">lr-gambatte</span><span style="color: red;">-record</span><span style="color: green;"> = "/opt/retropie/emulators/retroarch/bin/retroarch -L /opt/retropie/libretrocores/lr-gambatte/gambatte_libretro.so --config /opt/retropie/configs/gb/retroarch.cfg</span><span style="color: red;"> --record /home/pi/recording_GB_$(date +%Y-%m-%d-%H%M%S).mkv --recordconfig /home/pi/recording-config.cfg</span><span style="color: green;"> %ROM%"</span>
default = "lr-gambatte"
lr-tgbdual = "/opt/retropie/emulators/retroarch/bin/retroarch -L /opt/retropie/libretrocores/lr-tgbdual/tgbdual_libretro.so --config /opt/retropie/configs/gb/retroarch.cfg %ROM%"
```

The line I added is coloured:  The green parts are things copied from the line above, and the red parts are new - those parts tell the launcher to use the recording config we made in the previous section.

When you've made your edits, press Ctrl-X to exit `nano`, and type "Y" when it asks whether you want to save.

Once you've done something similar to this for every emulator you want to record with, you are ready to actually do the recording!

## Actually doing a recording

### Launching a game with recording turned on

In the normal RetroPie interface, go to your emulator and start it, but press the A button while it's launching, and choose "Select emulator for ROM".  In the list that comes up, choose the new line you added in emulators.cfg.  In our example, that was called "lr-gambatte-record".

Now play the game, and exit when you are finished.  If all goes well, the recording will have been saved!

(Note: doing this means that every time you launch this game it will be recorded.  To stop it doing this, press the "A" button while it's launching, choose "Select emulator for ROM" and choose the normal line - in our example that would be "lr-gambatte".)

### Getting the recorded files

To get your recording off the RetroPie, go back to your computer, open a terminal, and type:

```
scp pi@192.168.0.3:recording_*.mkv ./
```

This will copy all recorded videos from your RetroPie onto your computer (into your home directory, unless you did a `cd` commmand before you typed the above).

Now you should delete the files from your RetroPie.  Log in to the RetroPie as described in the first section, and delete all recording files by typing this:

**Note:** This deletes all your recordings, and you can't undo!

```
rm recording_*.mkv
```

**Note:** This deletes all your recordings, and you can't undo!

### Safer: recording onto a USB stick

**Note**: recording directly onto the RetroPie like we described above is dangerous because you could fill up all the disk space or corrupt your SD card, which could make RetroPie stop working, meaning you need to wipe your SD card and set up RetroPie again.

It's safer and faster to record onto a separate USB disk. To find out how, read "Recording to an External Storage Device" in [Retro Resolution's guide](https://retroresolution.com/2016/07/06/recording-live-gameplay-in-retropies-retroarch-emulators-natively-on-the-raspberry-pi/#li_performance_external_hdd): change the `--record` parameter in your launch config to point to your USB stick (probably something like `/media/usb0/` but check beforehand).

If you want to grab your recordings easily from another PC, you can save them in a "captures" subfolder in the main roms folder, and then access the roms share by navigating to `\\retropie\roms`.

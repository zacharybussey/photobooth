Photobooth
==========

This is a photobooth application, written in Elixir.
The intent is to have a set and forget photobooth running an event,
taking high quality pictures from a DSLR camera, and combining them into a photostrip which could be printed out.
A more in depth explanation can be found on my blog: zachdevelop.com

##How to get this to work

###Install Erlang and Elixir
Erlang from
```shell
sudo apt-get install erlang-mini
```

Elixir from the source.

###Install Cups and a driver for your printer

###Install GraphicsMagik
```shell
sudo apt-get install graphicsmagik
```

###Install GPhoto2 and other libs
Download this script, which will download and build everything for you
https://github.com/gonzalo/gphoto2-updater

Then, you have to remove a few monitor files to get the program
to run without issue

```shell
sudo rm /usr/share/dbus-1/services/org.gtk.Private.GPhoto2VolumeMonitor.service

sudo rm /usr/share/gvfs/mounts/gphoto2.mount

sudo rm /usr/share/gvfs/remote-volume-monitors/gphoto2.monitor

sudo rm /usr/lib/gvfs/gvfs-gphoto2-volume-monitor
```


###GPIO pins

To avoid permission access issues when making calls from the program to the GPIO pins,
install the wiring pi project:
https://projects.drogon.net/raspberry-pi/wiringpi/download-and-install/

OS commands are sent to setup the pins for import and export as needed, since
the Elixir library that talks the pins tended to run into access exceptions.

###Hardware

The code expects there to be one button and four leds.  You may
need to adjust the pins, depending on your setup.  The shutter control button
is connected to pin 17, and the leds are connected to pins 21 to 24.

###Running the program

mix deps.get
mix escript.build
./photobooth

Photobooth
==========

** TODO: Add description **

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

Setup an add yourself to a group, so that the pins can be
accessed without permissions errors.
```shell
sudo groupadd gpio
sudo usermod -aG gpio <myusername>
su <myusername>
sudo chgrp gpio /sys/class/gpio/export
sudo chgrp gpio /sys/class/gpio/unexport
sudo chmod 775 /sys/class/gpio/export
sudo chmod 775 /sys/class/gpio/unexport
```

###Hardware

The code expects there to be two buttons and four leds.  You may
need to adjust the pins, depending on your setup.

###Running the program

mix deps.get
mix escript.build
./photobooth

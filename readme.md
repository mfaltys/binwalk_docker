# DLink DCS-930L firmware dump
This repo is dedicated to creating a reproducable docker image that is able to
traverse firmware from the DLink DCS-930L. In the docker image, we start out
with ubuntu (only OS that I could get to reliable run binwalk) and add compile
binwalk from source. From here we can grab the firmware package and
extract/traverse with binwalk.

## Building the image
We can build the image with make. Issue `make` or `make build` to build the
image. This requires `docker` and `make` to be installed.

## Traversing the filesystem
Now that the image has been built we can traverse the DLink DCS-930L disk image
with `make enter`. This will run a docker command to put you right at the base
of the extracted firmware.

## Areas of note
We want to track down what is being started on boot, we should check the
inittab. From here we can see that 2 processes are being executed on boot,
`/etc_ro/rcS` and `/bin/login/`. The first process is being invoked on system
init, which happens right after the kernel is loaded into memory, so if we
follow this proccess we can see that it mounts all drives that are not mounted,
starts the ftpd (with no perms), and then invokes a script in `/sbin/` called 
`internet.sh`. `internet.sh` is an interesting file with an interesting name. It first
dynamically gets the login ID and model of the device which tells us this is
most likely used on more than one device.  We can see one line `if [ "$model" ==
"DCS-5000L" ]; then` which sets different logic if it matches the stored model
number. The internet scrip then proceeds to start the video stream from the
camera and configure networking to the feed.

```
inittab -> rcS -> internet.sh ->
```

- `/etc_ro/rcS`:
  ```
  45 #for telnet debugging
  46 #security issue - don't run telnetd here -- andy 2012-07-03
  47 #telnetd
  ```

- `internet.sh`: 
  - gets username and password from nvram
  - cowardly overwrites with `chpass.sh`
  - starts ftp daemon
  - starts video stream
  - brings network interfaces online

- 1337 easter eggs:
```
Welcome to  
   _______  _______  ___     __  ____   _  _   ___  
  |  ___  \|   __  ||   |   |__||    \ | || | /  /  
  | |___| ||  |__| ||   |__  __ |     \| || |/  /  
  |   _   /|   _   ||      ||  || |\     ||     \  
  |__| \__\|__| |__||______||__||_| \____||_|\___\  
   
                   =System Architecture Department=  
  
```

### TODO

```
/sbin/chpasswd.sh  
/etc_ro/servercert.pem  
/etc_ro/serverkey.pem  
/etc_ro/rcS  
/usr/sbin/telnetd  
/sbin/snort.sh`: leads us to belive snort is installed at /bin/snort.. it is not  
```

Ungoogled Chromium in a container
=================================

This docker image allows ungoogled chromium in a container. The installed
libraries should be enough to enable all functionality. Beyond the base
dependencies necessary to get the software running, the following libraries
are installed:

  * fonts-symbola: Support for emoticons
  * libcanberra-gtk3-0: Support for widget sounds, etc
  * i965-va-driver: Hardware acceleration for Intel integrated video hardware

Note that the image assumes uid/gid 1000, which is intended to match the likely
host uid/gid. This will allow you to mount download and configuation volumes
as the example usage below shows.

Utilizing a rootless container system like podman will allow you to run as root
instead, as root is mapped to the host uid/gid without additional security
exposure to the host.

Note that microphone usage is disabled by default in ungoogled chromium. To
enable the microphone, close down the container and run the following:

```sh
sed -i 's/"audio_capture_enabled":false/"audio_capture_enabled":true/'  ~/.config/chromium/Default/Preferences
```

See https://issues.guix.gnu.org/issue/36961 for more information

Example usage
-------------

```sh
docker run \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  -e DISPLAY="unix$DISPLAY" \
  -v /run/dbus/:/run/dbus/ \
  -v /dev/shm:/dev/shm \
  -v /etc/localtime:/etc/localtime:ro \
  --device /dev/dri \
  --device /dev/video0 \
  --group-add "$(getent group audio | cut -d: -f3)" \
  -e PULSE_SERVER="unix:${XDG_RUNTIME_DIR}/pulse/native" \
  -v "${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native" \
  -e LANG \
  -u "$(id -u):$(id -g)" \
  --group-add video \
  -d \
  --rm \
  -v "$HOME"/Downloads:"$HOME"/Downloads \
  -v "$HOME"/.config/chromium/:"$HOME"/.config/chromium \
  -v "$HOME"/.config/chromium-flags.conf:"$HOME"/.config/chromium-flags.conf:ro \
  -w "$PWD" -e HOME
  imagename
```

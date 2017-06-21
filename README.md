# Elementary Arc

**Note:** This is still a beta fork from an unfinished work.

At the moment this icon theme mainly includes icons for folders and mimetypes. I aim to include icons from elementary-xfce and elementary-plus icons.

### Requirements

This theme doesn't provide application icons, it needs another icon theme to inherit them.
By default this theme will look for the [elementary Xfce icon theme](https://github.com/shimmerproject/elementary-xfce) to get the missing icons. If elementary Xfce is not installed it will use the Gnome icon theme as fallback.

### Installation

Installation via autotools:

    git clone https://github.com/maeslor/ElementaryArc --depth 1 && cd ElementaryArc
    ./autogen.sh --prefix=/usr
    sudo make install

Alternatively you may copy the `Arc` folder to `~/.icons` or to `/usr/share/icons` for system-wide use.

### Uninstall

Run

    sudo make uninstall

from the same directory as this README resides in, or

    sudo rm -rf /usr/share/icons/Arc

### Preview
![Preview](https://i.imgur.com/yCO1aeP.png)

License: GPLv3

# Arc Icon Theme

**Note:** This is still unfinished. It may not work as expected in some cases.

At the moment this theme mainly includes icons for folders and mimetypes.

### Requirements

This theme doesn't provide application icons, it needs another icon theme to inherit them.
By default this theme will look for the [Moka icon theme](https://snwh.org/moka) to get the missing icons. If Moka is not installed it will use the Gnome icon theme as fallback.
To change the application icons, edit `Arc/index.theme` and replace `Moka` with the name of your preferred icon theme

For example, if you like the Faenza icon theme, change

    [Icon Theme]
    Name=Arc
    Inherits=Moka,Adwaita,gnome,hicolor
    Comment=Arc Icon theme

to

    [Icon Theme]
    Name=Arc
    Inherits=Faenza,Adwaita,gnome,hicolor
    Comment=Arc Icon theme

### Installation

Installation via autotools:

    git clone https://github.com/horst3180/arc-icon-theme --depth 1 && cd arc-icon-theme
    ./autogen.sh --prefix=/usr
    sudo make install

Alternatively you may copy the `Arc` folder to `~/.icons` or to `/usr/share/icons` for system-wide use.

#### Packages

Prebuilt packages for Ubuntu, Debian, Fedora and openSUSE are currently not available.

--

Arch Linux users can install the theme from the AUR

**Official Releases**: https://aur.archlinux.org/packages/arc-icon-theme/ 

**Development Releases**: https://aur.archlinux.org/packages/arc-icon-theme-git/

**Note:** If you're having trouble with the AUR packages please email the package maintainer at bil.elmoussaoui@gmail.com before creating an issue.

### Uninstall

Run

    sudo make uninstall

from the same directory as this README resides in, or

    sudo rm -rf /usr/share/icons/Arc

### Preview
![Preview](https://i.imgur.com/yCO1aeP.png)

License: GPLv3

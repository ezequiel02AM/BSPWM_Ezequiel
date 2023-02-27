#!/bin/bash
# Written by: SwallowYourDreams
name="video-wallpaper"
#installdir="/home/$USER/.local/bin"
installdir="/usr/local/bin"
xwinwrap_dl="https://github.com/mmhobi7/xwinwrap/releases/download/v0.9/xwinwrap"
dependencies=("mpv" "pcregrep" "xrandr" "python3-pyqt5")
missingDependencies=""
#installdir="/usr/local/share/$name"
#files=("$name.sh" "$name.py" "gui.ui" "xwinwrap")
files=("$name.sh" "xwinwrap")

check_dependencies() {
	# Downloading xwinwrap
	if [ ! -f "$installdir/xwinwrap" ] ; then
	    sudo wget "$xwinwrap_dl" -O "$installdir/xwinwrap"
	    sudo chmod +x "$installdir/xwinwrap"
	fi
	
	# Distro-agnostic mode
	if [ "$1" == "--distro-agnostic" ] ; then
		echo "You're running the installer in distro-agnostic mode. The automated dependency check and install will be skipped."
		echo "Please make sure that the following packages are present on your system: ${dependencies[@]}."
		echo "Note that the exact package name may vary, depending on your distro."
	# Check for dependencies in repositories
	else
		for d in ${dependencies[@]} ; do
			present=$(which "$d")
			if [ ${#present} -eq 0 ] ; then
				missingDependencies+=" $d"
			fi 
		done
		if [ "${#missingDependencies}" -gt 0 ] ; then
		      sudo apt install $missingDependencies
		      if [ $? != 0 ] ; then
			echo "Dependencies unfulfilled, aborting."
			exit 1
		      fi
		else
			echo "All dependencies are fulfilled."
		fi
	fi
}

install() {
	#mkdir -p $installdir
	for file in ${files[@]} ; do
		if [ "$file" != "xwinwrap" ] ; then
			sudo cp "./$file" $installdir
		fi
	done
	#if [ ! -f "/.local/share/applications/$name.desktop" ] ; then
	    #desktopFile=~/.local/share/applications/"$name".desktop
	    #sudo cp "./$name.desktop" ~/.local/share/applications
	    #desktopEntry="[Desktop Entry]\nType=Application\nName=Video Wallpaper\nExec=$name.py\nIcon=wallpaper\nComment=Set video files as your desktop wallpaper.\nCategories=Utility\nTerminal=false\n"
	    #sudo printf "$desktopEntry" > "$desktopFile"
	#fi
}

uninstall() {
	# Remove program files
	for file in ${files[@]} ; do
		sudo rm "$installdir/$file"
	done
	#rm ~/.local/share/applications/"$name".desktop # Menu entry
}

if [ "$1" == "" ] || [ "$1" == "--distro-agnostic" ]; then
	echo "This script will install $name to your machine." 
	check_dependencies "$1"
	install
elif [ "$1" == "--uninstall" ] ; then
	uninstall
else
	echo "Illegal parameter."
fi
